
## Atividade 27 - Lista de partículas por célula.

Posições geradas com:

```julia
import Random
Random.seed!(321)
p = [ 12*rand(2) for i in 1:10 ]
```

## Vetor first_atom: 

```julia
 first_atom[1,1] = 10
 first_atom[1,2] = 5
 first_atom[1,3] = 0
 first_atom[1,4] = 0
 first_atom[2,1] = 0
 first_atom[2,2] = 0
 first_atom[2,3] = 0
 first_atom[2,4] = 4
 first_atom[3,1] = 9
 first_atom[3,2] = 0
 first_atom[3,3] = 0
 first_atom[3,4] = 8
 first_atom[4,1] = 0
 first_atom[4,2] = 2
 first_atom[4,3] = 0
 first_atom[4,4] = 0


## Vetor next_atom: 

```julia
 next_atom[1] = 0
 next_atom[2] = 0
 next_atom[3] = 0
 next_atom[4] = 0
 next_atom[5] = 0
 next_atom[6] = 0
 next_atom[7] = 1
 next_atom[8] = 7
 next_atom[9] = 3
 next_atom[10] = 6
```


