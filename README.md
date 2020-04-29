# Chemical Kinetics / Pandemia Simulation

## Install with*

```
] add https://github.com/m3g/CKP
```
*This is a Julia package, so install Julia first, from: 
<a target=_Julia_ href=http://julialang.org>http://julialang.org</a>.

## "Atomistic" simulations

### Run "MD" sird simulation with default parameters
```
mdinput = CKP.MDInput()
trajectory = CKP.md()
```

### Write and read the trajectory to a file
```
CKP.write(mdinput,trajectory,"md.CKP")
mdinput, trajectory = CKP.read("md.CKP")
```

### Simulate with a different average kinetic energy 
#### equivalent to change temperature (default is 5.):
```
mdinput = CKP.MDInput(kavg_target=0.5)
trajectory = CKP.md(mdinput)
```

### Create animated gif 
```
CKP.animate(mdinput,trajectory,"animation.gif)
```

#### Example output plot:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/md.gif">
<br><br>

## SIRD simulation with default parameters
```
input = CKP.SIRDInput()
trajectory = CKP.sird(input)
```

### Simulate with a different rate constant for contamination 
```
input = CKP.SIRDInput(kc=0.8)
trajectory = CKP.sird(input)
```

### Create plot
```
CKP.plotsird(input,trajectory,"sird.pdf)
```

#### Example output plot:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/sird.png">
<br><br>

## Fit SIRD kinetic simulation to MD simulation data 
```
sirdinput, sirdtraj = CKP.fit(mdtrajectory)
```
where `mdtrajectory` is a trajectory obtained with `CKP.md`.

## Plot the fit
```
CKP.plotfit(mdinput,mdtraj,sirdinput,sirdtraj,"fitplot.pdf")
```
### Example output plot of the fit:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/fitplot.png">
<br><br>

## Plot the energy function used in MD simulation
```
mdinput = CKP.MDInput()
CKP.plotU(mdinput,"energy.pdf")
```
### Example output plot of the fit:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/energy.png">
<br><br>











