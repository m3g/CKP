#
# Simulation using the Berendsen thermostat
#

using Printf
using Random
Random.seed!(7654321)

function md(input :: Input)

  nprod = round(Int64,input.tmax/input.dt)

  # Check for input error
  if nprod%input.nsave != 0
    error("ERROR: (tmax/dt) must be a multiple of nsave ")
  end

  # Just to clear out the code
  n = input.n
  dt = input.dt
  if input.uf == "uf_QUAD!"
    uf! = uf_QUAD!
  else
    uf! = input.uf
  end

  # Initial point and data structures
  atoms, traj = initial(input)
  x = atoms.x # does not copy x, and cleares the code

  # Vectors for velocities and forces
  v = similar(x)
  forces = Forces(input)
  f = forces.f

  # Initial velocities are very small, to see thermalization
  for i in 1:n
    v[i,1] = normal(1.e-3*sqrt(input.kavg_target),1.e-3*input.kavg_target)
    v[i,2] = normal(1.e-3*sqrt(input.kavg_target),1.e-3input.kavg_target) 
  end
  kstep = kinetic(n,v)
  kavg = kstep / n
  println(" kavg at initial point: ", kavg)

  # Forces and energy at initial point
  u = uf!(n,x,forces,input)
  kini = kinetic(n,v)

  println(" Potential energy at initial point: ", u)
  println(" Kinetic energy at initial point: ", kini)
  eini = u + kini
  println(" Total initial energy = ", eini)
  flast = copy(f)

  #
  # Equilibration
  #
  iequil = input.nequil
  time = 0.
  kavg20 = zeros(20)
  istep = 0
  while iequil != 0
    istep = istep + 1
    
    # update time
    time = time + dt

    # update positions
    update_positions!(atoms,f,v,input)

    # compute forces and energy at this point
    @. flast = f
    kstep = kinetic(n,v) 
    ustep = uf!(n,x,forces,input)
    energy = kstep + ustep 
    kavg = kstep / n

    # Stop if average kinetic energy of last 20 points is good enough
    if input.nequil < 0 
      if istep < 20
        kavg20[istep] = kavg
      else
        kavg20[1:19] = kavg20[2:20]
        kavg20[20] = kavg
      end
      kavg_last20 = sum(kavg20)/20
      if abs(kavg_last20-input.kavg_target) < input.kavg_tol
        iequil = 0 
        println(" Satisfactory equilibration achieved in last 20 steps: ",kavg_last20)
      end
    # Stop if number of steps of equilibration was achieved
    else
      iequil = iequil - 1 
    end

    # Stop if simulation exploded
    if ustep > 1.e10
      println("STOP: Simulation exploded at step ", istep, " with energy = ", energy)
      return traj
    end
  
    # Print data on screen
    if istep%input.iprint-1 == 0
      println(@sprintf(" EQUIL TIME= %12.5f U = %12.5f K_avg = %12.5f TOT = %12.5f ", time, ustep, kavg, energy))
    end
   
    # Update velocities (using Berendsen rescaling)
    update_velocities!(v,kavg,f,flast,input)

  end

  # Save initial point
  ustep, nenc = uf!(n,atoms,forces,input)
  kstep = kinetic(n,v) 
  nsave = 1
  for i in 1:n
    traj.atoms[nsave].x[i,1] = atoms.x[i,1]
    traj.atoms[nsave].x[i,2] = atoms.x[i,2]
    traj.atoms[nsave].status[i] = atoms.status[i]
  end
  traj.potential[nsave] = ustep
  traj.kinetic[nsave] = kstep
  traj.total[nsave] = ustep + kstep
  traj.time[nsave] = 0.
  traj.nenc[nsave] = nenc

  # 
  # Running simulation
  #
  println(" Running simulation: ")
  nsteps = nprod
  println(" Number of steps: ", nsteps)
  isave = round(Int64,nprod/input.nsave)
  println(" Saving trajectory at every ", isave, " steps.")
  for istep in 2:nsteps

    # update time
    time = (istep-1)*dt

    # Updating positions 
    update_positions!(atoms,f,v,input)

    # compute forces and energy at this point
    @. flast = f
    kstep = kinetic(n,v) 
    ustep, nenc = uf!(n,atoms,forces,input)
    energy = kstep + ustep 
    kavg = kstep / n

    # Stop if simulation exploded
    if ustep > 1.e10
      println("STOP: Simulation exploded at step ", istep, " with energy = ", energy)
      return traj
    end

    # Print data on screen
    if istep%input.iprint-1 == 0
      println(@sprintf(" PROD TIME= %12.5f U = %12.5f K_avg = %12.5f TOT = %12.5f ", time, ustep, kavg, energy))
    end
   
    # Save trajectory point
    if (istep)%isave == 0
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
      traj.nenc[nsave] = nenc
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
          x[i,1] = -input.side/2. + 0.05*input.side/2 + (input.side/n)*ndead
          x[i,2] = -input.side/2. + 0.05*input.side/2
        end
      end
    end

    # Update velocities (using Berendsen rescaling)
    update_velocities!(v,kavg,f,flast,input)

  end
  return traj

end 

