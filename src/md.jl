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

  println(" ----------------------------------------------------------------")
  println(" EQUILIBRATION")
  println(" ----------------------------------------------------------------")
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

    # compute forces and energy at this point
    @. flast = f
    ustep = uf!(n,x,forces,input)
    kstep = kinetic(n,v) 
    energy = kstep + ustep 
    kavg = kstep / n

    # update positions
    update_positions!(atoms,f,v,input)

    # Update velocities (using Berendsen rescaling)
    update_velocities!(v,kavg,f,flast,input)

    # update time
    time = istep*dt

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
   
  end

  # 
  # Running simulation
  #
  println(" ----------------------------------------------------------------")
  println(" PRODUCTION")
  println(" ----------------------------------------------------------------")
  nsteps = nprod
  println(" Number of steps: ", nsteps)
  isave = round(Int64,nprod/input.nsave)
  println(" Saving trajectory at every ", isave, " steps.")
  nsaved = 0
  for istep in 1:nsteps

    # compute forces and energy at this point
    @. flast = f
    kstep = kinetic(n,v) 
    ustep, nenc = uf!(n,atoms,forces,input)
    energy = kstep + ustep 
    kavg = kstep / n

    # Updating positions 
    update_positions!(atoms,f,v,input)

    # Update velocities (using Berendsen rescaling)
    update_velocities!(v,kavg,f,flast,input)

    # update time
    time = istep*dt

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

    # Stop if simulation exploded
    if ustep > 1.e10
      println("STOP: Simulation exploded at step ", istep, " with energy = ", energy)
      return traj
    end

    # Print data on screen
    if istep%input.iprint == 0
      println(@sprintf(" PROD TIME= %12.5f U = %12.5f K_avg = %12.5f TOT = %12.5f ", time, ustep, kavg, energy))
    end
   
    # Save trajectory point
    if istep%isave == 0
      nsaved = nsaved + 1
      for i in 1:n
        traj.atoms[nsaved].x[i,1] = atoms.x[i,1]
        traj.atoms[nsaved].x[i,2] = atoms.x[i,2]
        traj.atoms[nsaved].status[i] = atoms.status[i]
      end
      traj.potential[nsaved] = ustep
      traj.kinetic[nsaved] = kstep
      traj.total[nsaved] = energy
      traj.time[nsaved] = time
      traj.nenc[nsaved] = nenc
    end
 
  end
  return traj

end 

