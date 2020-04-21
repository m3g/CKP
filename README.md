# Chemical Kinetics / Pandemia Simulation

## Install with

```
] add https://github.com/m3g/ckp
```

## Run with default parameters
```
input = CKP.input()
trajectory = CKP.md()
```

## Create animated gif 
```
CKP.animate(trajectory,input,"animation.gif)
```

## Simulate with a different average kinetic energy 
### Or change temperature (default is 5.):
```
input = CKP.input(kavg_target=0.5)
trajectory = CKP.md()
```

