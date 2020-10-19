
Posições geradas com:

```
import Random
Random.seed!(321)
p = [ 12*rand(2) for i in 1:10 ]
```

E usando um radio de corte de `3.0` para definir as celas.

Resultado esperado:

```
 Particle   1, p = [  7.5682, 10.9488 ], cell = [   3,   4 ]
 Particle   2, p = [  9.4241,  3.7574 ], cell = [   4,   2 ]
 Particle   3, p = [  8.7116,  0.6073 ], cell = [   3,   1 ]
 Particle   4, p = [  4.6170, 11.8838 ], cell = [   2,   4 ]
 Particle   5, p = [  0.7960,  3.3961 ], cell = [   1,   2 ]
 Particle   6, p = [  1.6040,  0.3515 ], cell = [   1,   1 ]
 Particle   7, p = [  8.2180, 11.6414 ], cell = [   3,   4 ]
 Particle   8, p = [  7.7043, 10.0519 ], cell = [   3,   4 ]
 Particle   9, p = [  8.5077,  2.0476 ], cell = [   3,   1 ]
 Particle  10, p = [  1.8722,  0.4591 ], cell = [   1,   1 ]
```
