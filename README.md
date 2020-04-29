# Chemical Kinetics / Pandemia Simulation

## Install with

```
] add https://github.com/m3g/CKP
```

## "Atomistic" simulations

### Run "MD"sird simulation with default parameters
```
mdinput = CKP.MDInput()
trajectory = CKP.md()
```

### Create animated gif 
```
CKP.animate(mdinput,trajectory,"animation.gif)
```

### Write and read the trajectory to a file
```
CKP.write(mdinput,trajectory,"md.CKP")
mdinput, trajectory = CKP.read("md.CKP")
```

### Simulate with a different average kinetic energy 
#### Or change temperature (default is 5.):
```
mdinput = CKP.MDInput(kavg_target=0.5)
trajectory = CKP.md(mdinput)
```
### Example output plot:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/md.gif">
<br><br>

## SIRD simulation with default parameters
```
input = CKP.SIRDInput()
trajectory = CKP.sird(input)
```

### Create plot
```
CKP.plotsird(input,trajectory,"sird.pdf)
```

### Simulate with a different rate constant for contamination 
```
input = CKP.SIRDInput(kc=0.8)
trajectory = CKP.sird(input)
```

### Example output plot:
<p align="center">
<img height=400px src="https://raw.githubusercontent.com/m3g/CKP/master/figures/sird.png">
<br><br>

## Fit SIRD simulation to MD simulation data 
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











