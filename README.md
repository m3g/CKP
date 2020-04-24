# Chemical Kinetics / Pandemia Simulation

## Install with

```
] add https://github.com/m3g/CKP
```

## Run "MD" simulation with default parameters
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
## Example output plot:
<p align="center">
<img src="https://raw.githubusercontent.com/m3g/CKP/master/figures/md.gif">
<br><br>

## Run SIRD simulation with default parameters
```
input = CKP.SIRDInput()
trajectory = CKP.sird(input)
```

## Create plot
```
CKP.sirdplot(trajectory,input,"sird.pdf)
```

## Simulate with a different rate constant for contamination 
```
input = CKP.SIRDInput(kc=0.8)
trajectory = CKP.sird(input)
```

## Example output plot:
<p align="center">
<img src="https://raw.githubusercontent.com/m3g/CKP/master/figures/sird.png">
<br><br>
