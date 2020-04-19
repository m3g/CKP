#
# Performs a simulations with a Langevin thermal coupling
#
# tprod: total runnning time
#

using Printf

function md(tprod,ff :: ForceField)

  # Number o particles

  n = 100

  x = zeros(n,2) # positions
  v = zeros(n,2) # velocities
  f = zeros(n,2) # forces

  flast = zeros(n,2) # forces in last step
 
  # Simulation parameters

  tprod = 2000.
  tprint = 1.
  tprintxyz = 2.
  printvel = false

  # Time-step

  dt = 0.05

  # Friction parameter for Langevin bath

  lambda = 0.5

  # Target average kinetic energy (equals to kT for 2D)

  kavg_target = 0.6

  # Initialize indices and coordinates

  totaltime = tprod
  nsteps = round(Int64,totaltime/dt)
  iprint = round(Int64,tprint/dt)
  iprintxyz = round(Int64,tprintxyz/dt) 

  # Initial coordinates

  initial!(n,x,ff)


  # Here we will initialize with null velocities, to see thermalization

  for i in 1:n
    v[i,1] = 0.
    v[i,2] = 0.
  end

  println(" Potential energy at initial point: ", potential(n,x,ff))
  println(" Kinetic energy at initial point: ", kinetic(n,v))
  eini = potential(n,x,ff) + kinetic(n,v)
  kini = kinetic(n,v)
  println(" Total initial energy = ", eini)
  force!(n,x,f,ff)

  # Running simulation

  time = 0.

  # Trajectory file

  trajfile = open("trajectory.xyz","w")
  printx(trajfile,n,x,0.,ff)

  for istep in 1:nsteps

    # Updating positions

    for i in 1:n
      x[i,1] = image(x[i,1] + v[i,1]*dt + 0.5*f[i,1]*dt^2,ff)
      x[i,2] = image(x[i,2] + v[i,2]*dt + 0.5*f[i,2]*dt^2,ff)
    end

    # Updating deterministic forces

    for i in 1:n
      flast[i,1] = f[i,1]
      flast[i,2] = f[i,2]
    end
    force!(n,x,f,ff)

    # Add friction force

    for i in 1:n
      f[i,1] = f[i,1] - lambda*v[i,1]
      f[i,2] = f[i,2] - lambda*v[i,2]
    end

    # Updating velocities; v = v + 0.5*(f1/m+f2/m)dt - lambda v dt + sqrt(2 lambda kT dt) * normal

    for i in 1:n
      v[i,1] = v[i,1] + 0.5*(f[i,1]+flast[i,1])*dt + sqrt(2*lambda*kavg_target*dt)*normal(0.,1.)
      v[i,2] = v[i,2] + 0.5*(f[i,2]+flast[i,2])*dt + sqrt(2*lambda*kavg_target*dt)*normal(0.,1.)
    end

    time = time + dt
    kstep = kinetic(n,v) 
    ustep = potential(n,x,ff)
    energy = kstep + ustep 
    kavg = kstep / n

    if istep%iprint == 0
      println(@printf(" TIME= %12.5f U = %12.5f K = %12.5f TOT = %12.5f ", time, ustep, kstep, energy))
    end
    if istep%iprintxyz == 0 
      printx(trajfile,n,x,time,ff)
    end
    plot!(

    # Stop if simulation exploded

    if ustep > 1.e10
      println(" Simulation exploded: Energy = ", energy)
      break
    end

  end

  close(trajfile)

end

