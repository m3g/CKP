
## ERROR: MethodError: no method matching....

Este tipo de erro é comum, e está relacionado com uma das
características fundamentais da linguagem Julia, que é o *despacho
múltiplo*. Despacho múltiplo é a propriedade de que uma função se
especialize, ou seja definida de forma especializada, para diferentes
tipo de variáveis de entrada.  

Por exemplo, se definirmos a seguinte função:

```julia
julia> f(x) = 2*x
f (generic function with 1 method)

```

Temos uma função que pode receber diferentes tipos de variáveis (como
escalares inteiros ou reais, vetores, etc), e a função será
especializada no momento da execução para cada tipo de variável. A
*macro* `@code_typed` mostra a representação da função em um nível mais
baixo, quando executada com diferentes argumentos. Com um número
inteiro, temos:

```julia
julia> @code_typed f(1)
CodeInfo(
1 ─ %1 = Base.mul_int(2, x)::Int64
└──      return %1
) => Int64

```

Note que temos uma chamada da função `Base.mul_int`. Se chamarmos a
função com um número real, temos uma função que converte o número `2` em 
um número real e depois faz um multiplicação com a função especializada
em números reais.  

```julia
julia> @code_typed f(1.0)
CodeInfo(
1 ─ %1 = Base.sitofp(Float64, 2)::Float64
│   %2 = Base.mul_float(%1, x)::Float64
└──      return %2
) => Float64

```

O código que nós definimos para `f(x)` foi um só, que foi
automaticamente especializado para o tipo de variável. 

Podemos, no entanto, definir funções para as quais restringimos o tipo
de variável que devem receber. Por exemplo, vamos fazer uma função que
só atua sobre números, mas não pode atuar sobre vetores:

```julia
julia> g(x::Number) = x + 1
g (generic function with 1 method)

julia> g(1)
2

julia> g(2.0)
3.0

```

Até aqui nenhuma surpresa. Definir a função dessa forma nos ajuda a
controlar melhor que o programa não tenha erros de determinados tipo,
especificamente, que o programa não chame a função `g` com um argumento
que não é um número. Se fizermos isso, vamos receber a mensagem de erro 
de método:

```julia
julia> x = [1,2]
2-element Array{Int64,1}:
 1
 2

julia> g(x)
ERROR: MethodError: no method matching g(::Array{Int64,1})
Closest candidates are:
  g(::Number) at REPL[1]:1

```

Desta forma, se você tem este tipo de erro no seu programa, significa
que uma função que deveria receber um tipo de variável está sendo
chamada com outro tipo de variável para a qual nenhum *método* desta
função está definido. Procure em que chamada da função isso está
ocorrendo, e verifique o tipo de variável que está sendo fornecida como
parâmetro de entrada, e o tipo de variável que deveria estar sendo
passado. De fato, estas duas informações são o que a mensagem de erro
mostra (acima). 

Também vamos ter o mesmo tipo de erro se tentarmos chamar a função com um
conjunto de variáveis diferente do esperado. As funções acima esperam
receber uma única variável como argumento. Se chamarmos uma delas
com dois argumentos, o mesmo tipo de erro aparece, porque não há um 
método definido para `g` que espera duas variáveis:

```julia
julia> g(2,3)
ERROR: MethodError: no method matching g(::Int64, ::Int64)

```


A vantagem, neste caso, de definir uma função especializada para
números, é que a mensagem de erro seria menos clara se deixássemos
função receber um vetor, mas uma operação dentro da função não estivesse
definida para vetores. A soma de um escalar não é algo definido para
vetores, portanto, neste caso, teríamos:

```julia
julia> h(x) = x + 1
h (generic function with 1 method)

julia> x = [1,2]
2-element Array{Int64,1}:
 1
 2

julia> h(x)
ERROR: MethodError: no method matching +(::Array{Int64,1}, ::Int64)
For element-wise addition, use broadcasting with dot syntax: array .+ scalar

```

Note que é o mesmo tipo de mensagem, mas que diz que a função adição
(`+`) não está definida entre um escalar e um vetor. Como não foi você
que definiu a função adição, é mais provável que este erro seja mais
difícil de entender que o erro que diz que *você* não definiu nenhum
método para `h` que deve atuar sobre vetores.

Podemos, no entanto, definir um método especializado para vetores.
Continuando com as definições de `h`, podemos definir agora:

```julia
julia> h(x::Vector) = x .+ 1
h (generic function with 2 methods)

```

Note que `h` agora tem *dois* métodos. O que mudamos aqui foi a adição
do `.` na função adição (escrevemos `.+`), que é uma maneira compacta de
dizer que o que queremos fazer é somar o número 1 a todos os elementos
do vetor `x`. 

Se agora chamarmos a função `h` com um vetor, o *método* mais específico
que foi definido para aquele tipo aquele tipo de variável vai ser utilizado:

```julia
julia> x = [1,2]
2-element Array{Int64,1}:
 1
 2

julia> h(x)
2-element Array{Int64,1}:
 2
 3

```

Neste caso `x` é um vetor de números inteiros. `h` tem dois métodos, um
sem nenhuma especialização, que foi nossa primeira definição, e outro
especializado em vetores. A versão especializada em vetores foi
acionada. Poderíamos definir uma versão ainda mais especializada, que
atue só sobre vetores de números inteiros:

```julia
julia> h(x :: Vector{Int}) = x .+ 2
h (generic function with 3 methods)

```
Note que agora vou somar `2` aos elementos do vetor. O que quero mostrar
aqui é que, havendo 3 métodos, sendo que dois deles atuam sobre vetores,
é o método mais específico que vai ser invocado sempre:

```julia
julia> x = [1,2] # vetor de inteiros
2-element Array{Int64,1}:
 1
 2

julia> h(x)
2-element Array{Int64,1}:
 3
 4

julia> x=[1.0,2.0] # vetor de reais
2-element Array{Float64,1}:
 1.0
 2.0

julia> h(x)
2-element Array{Float64,1}:
 2.0
 3.0

```

Naturalmente, é uma prática pouco recomendada definir diferentes métodos
para uma mesma função que fazem coisas logicamente diferentes e
inesperadas. 




































