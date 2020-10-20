
## Nota técnica: declaração de vetor de inteiros vs. declaração de vetores de qualquer tipo

No código [run-mindist.jl](./run-mindist.jl), geramos a matriz que
contém as partículas de cada célula usando:

```julia
cellparticles = [ Int64[] for i in 1:n, j in 1:n ]

``` 

Note que tomamos o cuidado de "avisar" ao programa que os vetores em
cada posição (i,j) desta matriz seria um vetor de números inteiros.

Em seguida, acrescentamos os índices das partículas que estavam em cada
posição da matriz usando, por exemplo, para acrescentar a partícula 5 à
posição (1,1) da matriz,

```julia
push!(cellparticles[1,1],5)

```

O vetor `cellparticles` poderia ter sido inicializado também da seguinte
forma:

```julia
cellparticles = [ [] for i in 1:n, j in 1:n ]

``` 

sendo que a única diferença é que em lugar de usar `Int64[]`, usando
somente `[]`. Esta diferença parece inocente, mas não é. Quando usando
`Int64[]`, podemos verificar em seguida que o tipo de variável que é
cada vetor está bem determinado. Vamos fazer um exemplo simplificado da
mesma coisa:

```julia
julia> x = [ Int64[] for i in 1:3 ];

julia> typeof(x[1])
Array{Int64,1}

```

Se, por outro lado, usamos `[]`, temos:

```julia
julia> x = [ [] for i in 1:3 ];

julia> typeof(x[1])
Array{Any,1}

```

No primeiro caso, o primeiro elemento do vetor `x` (que é um vetor
também), é de números inteiros. No segundo caso, pode ser qualquer
coisa. Efetivamente, em um caso podemos acrescentar uma outra coisa ao
vetor em `x[1]`:

```julia
julia> x = [ [] for i in 1:3 ];

julia> push!(x[1],"a")
1-element Array{Any,1}:
 "a"

```

Mas, no outro caso, não:

```julia
julia> x = [ Int64[] for i in 1:3 ];

julia> push!(x[1],"a")
ERROR: MethodError: Cannot `convert` an object of type String to an object of type Int64

```

Desta forma, todas as contas podem ser especializadas para atuar sobre
números inteiros se a declaração é mais específica, e não poderão se
especializar para números inteiros se a declaração for genérica. Estas
diferenças têm importantes implicações na performance de programas que
façam contas com estes vetores. 

Por exemplo, vamos definir uma função que soma todos os elementos de
todos os vetores contidos no vetor de vetores:

```julia
julia> function s(x)
         s = 0 
         for element in x
           for val in element
             s = s + val
           end
         end
         s
       end
s (generic function with 1 method)

```

E vamos definir um vetor de vetores maior, sem especificar o tipo exato
de vetor:

```julia
julia> x = [ isodd(i) ? [1] : [] for i in 1:10_000 ]
10000-element Array{Array{T,1} where T,1}:
 [1]
 Any[]
 [1]
...

```

e vamos avaliar a soma dos elementos:

```julia
julia> @btime s($x)
  147.353 μs (4489 allocations: 70.14 KiB)
5000

```

Note que foram feitas muitas alocações de memória. Agora, vamos fazer o
mesmo, mas especificando que todos os vetores devem ser de números
inteiros: 

```julia
julia> x = [ isodd(i) ? [1] : Int64[] for i in 1:10_000 ]
10000-element Array{Array{Int64,1},1}:
 [1]
 []
 [1]
...

```

E façamos o mesmo benchmark:

```julia
julia> @btime s($x)
  12.954 μs (0 allocations: 0 bytes)
5000

```

O resultado pode ser surpreendente: o tempo de execução caiu quase dez
vezes e, ainda, as alocações foram reduzidas a zero. 

Qual a diferença? A diferença está em que na função `s`, quando fazemos
a conta  

```julia
s = s + val

```

em um caso `val` pode ser qualquer coisa (uma letra, por exemplo). Nesse
caso, a função soma não faz sentido. O programa tem que testar, para
cada elemento, se a soma faz sentido ou não antes de fazer a soma (isso
é o que linguagens interpretadas como Python, R, Matlab, etc, fazem).
Esses testes envolvem alocações de memória e custam muito tempo
computacional relativamente à conta em si. No segundo caso, não é
necessário testar nada, porque o programa já sabe de entrada que o que
se espera é a uma soma de números inteiros (com a única exceção que o
segundo termo seja vazio, em cujo caso a especialização se mantém). 

### `@code_wartype`: Detectando instabilidades de tipo 

Esse problema se chama "instabilidade de tipos". São muito prejudiciais
para a eficiência de códigos em geral. Para evitar, ou encontrar, esse
tipo de problema no seu programa, existe a macro `@code_warntype`.
Vamos ver o que ela indicaria neste caso.

Se executarmos a função com o vetor de tipo indeterminado, temos:

```julia
julia> x = [ isodd(i) ? [1] : [] for i in 1:10_000 ];

julia> @code_warntype s(x)
Variables
  #self#::Core.Compiler.Const(s, false)
  x::Array{Array{T,1} where T,1}
  s::Any
  @_4::Union{Nothing, Tuple{Array{T,1} where T,Int64}}
  element::Array{T,1} where T
  @_6::Union{Nothing, Tuple{Any,Int64}}
  val::Any

Body::Any
1 ─       (s = 0)
│   %2  = x::Array{Array{T,1} where T,1}
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4 === nothing)::Bool
│   %5  = Base.not_int(%4)::Bool
└──       goto #7 if not %5
2 ┄ %7  = @_4::Tuple{Array{T,1} where T,Int64}::Tuple{Array{T,1} where T,Int64}
│         (element = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Int64
│   %10 = element::Array{T,1} where T
│         (@_6 = Base.iterate(%10))
│   %12 = (@_6 === nothing)::Bool
│   %13 = Base.not_int(%12)::Bool
└──       goto #5 if not %13
3 ┄ %15 = @_6::Tuple{Any,Int64}::Tuple{Any,Int64}
│         (val = Core.getfield(%15, 1))
│   %17 = Core.getfield(%15, 2)::Int64
│         (s = s + val)
│         (@_6 = Base.iterate(%10, %17))
│   %20 = (@_6 === nothing)::Bool
│   %21 = Base.not_int(%20)::Bool
└──       goto #5 if not %21
4 ─       goto #3
5 ┄       (@_4 = Base.iterate(%2, %9))
│   %25 = (@_4 === nothing)::Bool
│   %26 = Base.not_int(%25)::Bool
└──       goto #7 if not %26
6 ─       goto #2
7 ┄       return s

```

Há vários `Any` neste resultado (que estarão em vermelho e negrito no
seu REPL, se executar estes comandos lá). Eles indicam instabilidades de
tipo, e proavelmente indicam que alguma coisa pode ser melhorada no
código.

Alternativamente, usando o vetor com declaração de tipo mais específica,
não temos mais nenhum `Any` (e nenhuma marcação vermelha mais na saída,
se executada no REPL), indicando que o código é tipo-estável e vai poder
ser especializado e, portanto, rápido.

```julia
julia> @code_warntype s(x)
Variables
  #self#::Core.Compiler.Const(s, false)
  x::Array{Array{Int64,1},1}
  s::Int64
  @_4::Union{Nothing, Tuple{Array{Int64,1},Int64}}
  element::Array{Int64,1}
  @_6::Union{Nothing, Tuple{Int64,Int64}}
  val::Int64

Body::Int64
1 ─       (s = 0)
│   %2  = x::Array{Array{Int64,1},1}
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4 === nothing)::Bool
│   %5  = Base.not_int(%4)::Bool
└──       goto #7 if not %5
2 ┄ %7  = @_4::Tuple{Array{Int64,1},Int64}::Tuple{Array{Int64,1},Int64}
│         (element = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Int64
│   %10 = element::Array{Int64,1}
│         (@_6 = Base.iterate(%10))
│   %12 = (@_6 === nothing)::Bool
│   %13 = Base.not_int(%12)::Bool
└──       goto #5 if not %13
3 ┄ %15 = @_6::Tuple{Int64,Int64}::Tuple{Int64,Int64}
│         (val = Core.getfield(%15, 1))
│   %17 = Core.getfield(%15, 2)::Int64
│         (s = s + val)
│         (@_6 = Base.iterate(%10, %17))
│   %20 = (@_6 === nothing)::Bool
│   %21 = Base.not_int(%20)::Bool
└──       goto #5 if not %21
4 ─       goto #3
5 ┄       (@_4 = Base.iterate(%2, %9))
│   %25 = (@_4 === nothing)::Bool
│   %26 = Base.not_int(%25)::Bool
└──       goto #7 if not %26
6 ─       goto #2
7 ┄       return s

```















