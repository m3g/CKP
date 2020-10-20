
## Benchmark de funções que modificam os argumentos

Funções em geral podem ser avaliadas com o pacote `BenchmarkTools`,
usando:

```julia
using BenchmarkTools
@btime f($x)

```

A macro `@btime` geralmente faz múltiplas amostras, com múltiplas avaliações da função 
em cada amostra, para melhorar a medida de tempo. No entanto, há situações em que 
cada amostra só executar a função uma vez, com parâmetros novos. Por exemplo:

```julia
function f!(x,n)
  n[1] = n[1] + 1
  x[n[1]] = 0
end
```

A função acima recebe dois vetores, `x` e `n` como parâmetros, e modifica
os dois vetores. Uma execução sem erros desta função seria:

```julia
julia> n = [1];

julia> x = [1,2];

julia> f!(x,n);

julia> x
2-element Array{Int64,1}:
 1
 0

julia> n
1-element Array{Int64,1}:
 2

```

A função modificou os vetores `x` e `n`, zerando a segunda componente de `x`
e somando `1` à primeira componente de `n`. Se executarmos em seguida esta
função novamente, teremos um erro, porque `n[1]` vai assumir o valor `3`, 
e o vetor `x`, que deveria ser modificado na posição `n[1]`, só tem dois
elementos:

```
julia> f!(x,n)
ERROR: BoundsError: attempt to access 2-element Array{Int64,1} at index [3]

```

Portanto, esta função não pode ser executada duas vezes consecutivas sem que
o vetor `n` seja re-inicialiado como `n[1]=1`. Isto gera uma dificuldade na realização
de benchmarks: 

```julia
julia> n = [1];

julia> x = [1,2];

julia> @btime f!(x,n)
ERROR: BoundsError: attempt to access 2-element Array{Int64,1} at index [3]

```

Que é o mesmo erro acima, já que `@btime` tentou executar a função mais de uma
vez consecutiva.

Para resolver isso, temos que explicitamente dizer que queremos que cada amostra
do benchmark só tenha uma avaliação da função, e que o vetor tem que ser inicializado
antes de cada amostra:

```
julia> @btime f!(x,n) setup=(n=[1]) evals=1
  51.000 ns (0 allocations: 0 bytes)
2-element Array{Int64,1}:
 1
 0

```

O comando `setup` define o que precisa ser inicializado, e não é avaliado
como parte do benchmark, e `evals=1` define que cada amostra do benchmark é realizada
com uma única avaliação da função.







