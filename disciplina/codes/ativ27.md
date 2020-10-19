
## Atividade 25 - Inicialização de coordenadas e resultado esperado.

Posições geradas com:

```julia
import Random
Random.seed!(321)
p = [ 12*rand(2) for i in 1:10 ]
```

A classificação em células de raio de corte `3.0` destas partículas
deve resultar nas lista:

1. Número de partículas por célula (matriz de `4x4`):

```julia-repl
4×4 Array{Int64,2}:
 2  1  0  0
 0  0  0  1
 2  0  0  3
 0  1  0  0

```

2. Lista de partículas por célula (onde `[]` indica que não há nenhuma
partícula nessa célula):
```
4×4 Array{Array{Any,1},2}:
 [6, 10]  [5]  []  []
 []       []   []  [4]
 [3, 9]   []   []  [1, 7, 8]
 []       [2]  []  []

```



