
## Estabilidade de tipos e eficiência

Para ter um código eficiente é importante que o compilador seja capaz de
saber com que tipo de variável esta lidando. Quando uma variável pode
mudar de tipo de maneira imprevista, diz-se que temos que uma
*instabilidade de tipo*. 

Instabilidades de tipo geralmente surgem quando tentamos usar variáveis
globais dentro de funções, sem passar essas variáveis como parâmetros.
Vamos entender isto. 

Uma variável global é qualquer variável que é definida no *escopo
global*, ou seja, fora de qualquer função, ou módulo, ou outra estrutura
que define um escopo (`let`, por exemplo). Obtemos uma variável global
quando escrevemos, no REPL,

```julia
julia> x = 5. 
```

ou quando em um *script* escrevemos a mesma coisa diretamente:

```julia
x = 5.
```

Uma variável definida desta forma não tem estabilidade de tipo, porque
em qualquer momento você pode definir ela como qualquer outra coisa. Por
exemplo:

```julia
julia> x = 5.
5.0

julia> x = "ABC"
"ABC"

```

Agora, vamos definir uma função que usa o valor de `x`, sem passar `x`
como parâmetro. Esta função vai somar todos os elementos de `x`:

```julia-repl
julia> function f()
          s = 0
          for val in x
            s = s + val
          end
          return s
       end
f (generic function with 1 method)

```

Esta função não pode se especializar para o tipo de variável que é `x`
porque, como vimos, `x` pode ser qualquer coisa. Este problema em `f`
pode ser visto usando a macro `@code_warntype`:

```julia
julia> @code_warntype f()
Variables
  #self#::Core.Compiler.Const(f, false)
  s::Any
  @_3::Any
  val::Any

Body::Any
1 ─       (s = 0.0)
│   %2  = Main.x::Any
│         (@_3 = Base.iterate(%2))
│   %4  = (@_3 === nothing)::Bool
│   %5  = Base.not_int(%4)::Bool
└──       goto #4 if not %5
2 ┄ %7  = @_3::Any
│         (val = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Any
│         (s = s + val)
│         (@_3 = Base.iterate(%2, %9))
│   %12 = (@_3 === nothing)::Bool
│   %13 = Base.not_int(%12)::Bool
└──       goto #4 if not %13
3 ─       goto #2
4 ┄       return s


```

Note que há vários `Any` no código acima, que se você estiver no seu
REPL do Julia aparecerão em vermelho, para chamar a sua atenção de que
há algo que pode ser melhorado. Em particular, note a linha `Body::Any`.
Ela está querendo dizer que o resultado das operações do corpo da função
podem devolver qualquer tipo de variável, em princípio.

Vejamos a performance desta função (vamos definir `x` como um vetor de
muitas componentes para que o tempo de cálculo não seja muito curto e a
medida seja mais significativa):

```julia
julia> x = rand(1000);

julia> @btime f()
  60.148 μs (3490 allocations: 70.16 KiB)
492.360646736646

```

Agora, vamos definir uma nova função que recebe `x` como parâmetro, mas
que faz a mesma coisa:

```julia
julia> function g(x)
         s = zero(eltype(x))
         for val in x
           s = s + val
         end
         return s
       end

```

Fomos obsessivos neste exemplo, inicializando `s` como
`zero(eltype(x))`, que é um comando para dizer que `s` é o número zero
do mesmo tipo que os elementos de `x`. Ou seja, se `x` for um vetor de
números inteiros, `s` vai ser `0` (inteiro), se `x` for um vetor de
números reais, `s` vai ser `0.0` (real). Isto não vai ser fundamental
para a eficiência do código aqui, mas vai eliminar toda possível
instabilidade de tipo, inclusive no valor inicial de `s`. 

Agora, se chamarmos `g(x)` com um `x` de um determinado tipo, vai ser
criado um *método* desta função especializado para este tipo de
variável. Por exemplo, se chamarmos `g` com o número `1`, que é um
número inteiro, todas as operações em `g` são feitas com números
inteiros:

```julia
julia> @code_warntype g(1)
Variables
  #self#::Core.Compiler.Const(g, false)
  x::Int64
  s::Int64
  @_4::Union{Nothing, Tuple{Int64,Nothing}}
  val::Int64

Body::Int64
1 ─       (s = 0)
│   %2  = x::Int64
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4::Tuple{Int64,Nothing} === nothing)::Core.Compiler.Const(false, false)
│   %5  = Base.not_int(%4)::Core.Compiler.Const(true, false)
└──       goto #4 if not %5
2 ─ %7  = @_4::Tuple{Int64,Nothing}::Tuple{Int64,Nothing}
│         (val = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Core.Compiler.Const(nothing, false)
│         (s = s::Core.Compiler.Const(0, false) + val)
│         (@_4 = Base.iterate(%2, %9))
│   %12 = (@_4::Core.Compiler.Const(nothing, false) === nothing)::Core.Compiler.Const(true, false)
│   %13 = Base.not_int(%12)::Core.Compiler.Const(false, false)
└──       goto #4 if not %13
3 ─       Core.Compiler.Const(:(goto %7), false)
4 ┄       return s

```

Note que não há nenhum `Any` na representação do código acima e que, em
particular, o resultado das operações é `Body::Int64`, um número inteiro,
com certeza.

Se
chamarmos `g` com o número `3.14`, que é um número real, outro método é
gerado:

```julia
julia> @code_warntype g(3.14)
Variables
  #self#::Core.Compiler.Const(g, false)
  x::Float64
  s::Float64
  @_4::Union{Nothing, Tuple{Float64,Nothing}}
  val::Float64

Body::Float64
1 ─       (s = 0)
│   %2  = x::Float64
│         (@_4 = Base.iterate(%2))
│   %4  = (@_4::Tuple{Float64,Nothing} === nothing)::Core.Compiler.Const(false, false)
│   %5  = Base.not_int(%4)::Core.Compiler.Const(true, false)
└──       goto #4 if not %5
2 ─ %7  = @_4::Tuple{Float64,Nothing}::Tuple{Float64,Nothing}
│         (val = Core.getfield(%7, 1))
│   %9  = Core.getfield(%7, 2)::Core.Compiler.Const(nothing, false)
│         (s = s::Core.Compiler.Const(0, false) + val)
│         (@_4 = Base.iterate(%2, %9))
│   %12 = (@_4::Core.Compiler.Const(nothing, false) === nothing)::Core.Compiler.Const(true, false)
│   %13 = Base.not_int(%12)::Core.Compiler.Const(false, false)
└──       goto #4 if not %13
3 ─       Core.Compiler.Const(:(goto %7), false)
4 ┄       return s::Float64

```

Note que, agora, todos os tipos de variáveis que aparecem na função são
`Float64`.

Essa especialização não era possível quando `x` não era um parâmetro da
função, porque o *método* tinha ser capaz de lidar com qualquer tipo de
variável. 

Como fica a performance desta função, no mesmo teste acima? Vejamos, em
comparação com a `f` que não era especializada:

```julia
julia> x = rand(1000);

julia> @btime f()
  59.518 μs (3490 allocations: 70.16 KiB)
504.23960342930764

julia> @btime g($x)
  965.300 ns (0 allocations: 0 bytes)
504.23960342930764

```

A função `g` é cerca de 60 vezes mais rápida que `f`, e ainda por cima
não aloca nenhum espaço de memória.

Garantir que as funções tenham estabilidade de tipos, de forma que
possam ser gerados métodos especializados para cada tipo de variável que
a função recebe, é uma das coisas mais importantes na geração de códigos
eficientes. 

A mensagem, portanto, é que deve-se sempre evitar o uso de variáveis
globais que não tem um tipo definido constante. É possível ainda usar
variáveis globais, contanto que possamos garantir que elas tem um tipo
bem determinado, e isso se faz usando o comando `const`. Por exemplo: 

```julia
julia> const x = rand(1000);

julia> @btime f()
  963.300 ns (0 allocations: 0 bytes)
504.11877716593017

```

Mas é um hábito muito mais saudável passar as variáveis como parâmetros
das funções, porque o uso de constantes globais impede, por exemplo, que
você modifique o valor de `x` e rode a função novamente com outro
conjunto de dados.

