#
# Simulation using the Berendsen thermostat
#

using Printf
using Random
Random.seed!(7654321)

function md(input :: InputData)

  # Just to clear out the code
  n = input.n
  dt = input.dt

  # Initial point and data structures
  atoms, traj = initial(input)
  x = atoms.x # does not copy x, and cleares the code

  # Vectors for velocities and forces
  v = similar(x)
  f = similar(x)

  # Initial velocities are very small, to see thermalization

  for i in 1:n
    v[i,1] = -1. + 2*rand()
    v[i,2] = -1. + 2*rand()
  end
  kstep = kinetic(n,v)
  kavg = kstep / n
  for i in 1:n
    v[i,1] = v[i,1]*1e-5*sqrt(input.kavg_target/kavg)
    v[i,2] = v[i,2]*1e-5*sqrt(input.kavg_target/kavg)
  end

  u = forces_and_energy_simple!(n,x,f,input)
  kini = kinetic(n,v)

  println(" Potential energy at initial point: ", u)
  println(" Kinetic energy at initial point: ", kini)
  eini = u + kini
  println(" Total initial energy = ", eini)

  flast = copy(f)

  # Running simulation
  println(" Running simulation: ")
  nsteps = input.nequil + input.nprod
  println(" Number of steps: ", nsteps)
  isave = trunc(Int64,input.nprod/input.nsave)
  println(" Saving trajectory at every ", isave, " steps.")
  time = 0.
  nsave = 0
  for istep in 1:nsteps

    # Updating positions 
    for i in 1:n
      if atoms.status[i] == 2
        continue  
      end
      x[i,1] = image(x[i,1] + v[i,1]*dt + 0.5*f[i,1]*(dt^2),input)
      x[i,2] = image(x[i,2] + v[i,2]*dt + 0.5*f[i,2]*(dt^2),input)
    end

    time = time + dt
    # reset time
    if istep == input.nequil 
      time = 0.
    end

    # compute forces and energy at this point
    kstep = kinetic(n,v) 

    # Updating the force
    for i in 1:n
      flast[i,1] = f[i,1]
      flast[i,2] = f[i,2]
    end
    if istep <= input.nequil
      ustep = forces_and_energy_simple!(n,x,f,input)
    else
      ustep = forces_and_energy_simple!(n,atoms,f,input)
    end
    energy = kstep + ustep 
    kavg = kstep / n

    # Stop if simulation exploded
    if ustep > 1.e10
      println("STOP: Simulation exploded at step ", istep, " with energy = ", energy)
      return traj
    end

    # Print data on screen
    if istep%input.iprint-1 == 0
      if istep <= input.nequil
        println(@sprintf(" EQUIL TIME= %12.5f U = %12.5f K = %12.5f TOT = %12.5f ", time, ustep, kstep, energy))
      else
        println(@sprintf(" PROD TIME= %12.5f U = %12.5f K = %12.5f TOT = %12.5f ", time, ustep, kstep, energy))
      end
    end
   
    # Save trajectory point
    if istep > input.nequil && (istep-input.nequil-1)%isave == 0
      nsave = nsave + 1
      for i in 1:n
        traj.atoms[nsave].x[i,1] = atoms.x[i,1]
        traj.atoms[nsave].x[i,2] = atoms.x[i,2]
        traj.atoms[nsave].status[i] = atoms.status[i]
      end
      traj.potential[nsave] = ustep
      traj.kinetic[nsave] = kstep
      traj.total[nsave] = energy
      traj.time[nsave] = time
    end
 
    # Some sick people may dye, and other people may get immune
    if istep > input.nequil
      for i in 1:n
        if atoms.status[i] == 1
          # die
          if rand() < input.pdie
            atoms.status[i] = 2
          elseif rand() < input.pimmune
          # get immunity
            atoms.status[i] = 3
          end # otherwise continue sick
        end
      end
      ndead = 0
      # Check who died
      for i in 1:n
        # if dead, put aside
        if atoms.status[i] == 2
          ndead = ndead + 1
          x[i,1] = -48. + 0.4*ndead
          x[i,2] = -48. 
        end
      end
    end

    # Berendsen bath
    if istep <= input.nequil
      vx = 0.
      vy = 0.
      lambda = sqrt( 1 + (dt/input.tau)*(input.kavg_target/kavg-1) )
println(istep," ",input.kavg_target," ",kavg)
lambda = input.kavg_target/kavg
      for i in 1:n
        v[i,1] = v[i,1]*lambda
        v[i,2] = v[i,2]*lambda
        vx = vx + v[i,1]
        vy = vy + v[i,2]
      end
      # Remove drift
      vx = vx / n
      vy = vy / n
      for i in 1:n
        v[i,1] = v[i,1] - vx
        v[i,2] = v[i,2] - vy
      end
    end

    # Updating velocities
    for i in 1:n
      v[i,1] = v[i,1] + 0.5*(f[i,1]+flast[i,1])*dt
      v[i,2] = v[i,2] + 0.5*(f[i,2]+flast[i,2])*dt
    end

  end
  return traj

end 

