#
# Simulation of the SIRD epidemics model
#
# Mechanism:  U: Susceptible ; S: Sick ; D: Dead ; I : Immune
#             U + S -> 2S (kc: contamination)
#             S -> D (kd: death) 
#             S -> I (ki: immunization) 
#             I -> U (kiu: loss of immunity) 
#

# Diferential equations
dUdt(U,S,I,k) = -k[1]*U*S + k[4]*I
dSdt(U,S,k) = k[1]*U*S - (k[2]+k[3])*S
dDdt(S,k) = k[2]*S
dIdt(S,I,k) = k[3]*S - k[4]*I

# error
sird_error(U,S,D,I) = abs(1. - (U + S + D + I))

# A method that will be used if the trajectory structure was not created outside
function sird(input :: SIRDInput)
  traj = SIRDTraj(input)
  sird!(input,traj)
  return traj
end

# We need this layer for the optimization procedure to be able to receive a variable (modifies traj)
function sird!(input :: SIRDInput, traj :: SIRDTraj)
  k = [ input.kc, input.kd, input.ki, input.kiu ]
  sird!(k, input, traj)
end

# Function that performs the simulation, modifies the data in traj structure (modifies traj)
function sird!(k :: Vector{Float64}, input :: SIRDInput, traj :: SIRDTraj)

  # Number of steps
  dt = input.dt
  nsteps = round(Int64,input.tmax/dt)
  if nsteps%input.nsave != 0
    error(" In SIRD (tmax/dt) must be a multiple of nsave")
  end
  isave = round(Int64,nsteps/input.nsave)

  # To clear out the code
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  time = traj.time

  # Initial populations (p for "previous" to the first step)
  Sp = input.Si
  Dp = input.Di
  Ip = input.Ii
  if Sp + Dp + Ip > 1.
    error("Sum of sick, dead, and immune cannot be greater than 1.")
  end
  Up = 1. - (Sp+Dp+Ip)
   
  # Running simulation
  nlast = nsteps
  nsaved = 0
  for i in 1:nsteps
    # Update populations (c for current)
    Uc = Up + dUdt(Up,Sp,Ip,k)*dt
    Sc = Sp + dSdt(Up,Sp,k)*dt
    Dc = Dp + dDdt(Sp,k)*dt
    Ic = Ip + dIdt(Sp,Ip,k)*dt
    # Save data if required at this step
    if i%isave == 0
      nsaved = nsaved + 1
      U[nsaved] = Uc
      S[nsaved] = Sc
      D[nsaved] = Dc
      I[nsaved] = Ic
      time[nsaved] = i*dt
    end       
    # check if epidemics ended
    if Sc < input.tol
      nlast = i
      break
    end
    # check if integration is going fine
    err = sird_error(Uc,Sc,Dc,Ic)
    if err > input.err
      if input.print
        println(input.print," SIRD: Integration error too large at step: ", i," error = ",err)
      end
      nlast = i
      break
    end
    # Update previous values to current ones
    Up = Uc
    Sp = Sc
    Dp = Dc
    Ip = Ic
  end

  if input.print
    println(" Epidemics ended at step = ", nlast)
    println(" Last step saved = ", nsaved, " time = ", time[nsaved])
  end
  
  # Filling up vector up to the end, if the trajectory ended before
  if nsaved < input.nsave
    if nsaved == 0 # the simulation ended before the first point was saved
      for i in 1:input.nsave
        U[i] = Up
        S[i] = Sp
        D[i] = Dp
        I[i] = Ip
        time[i] = i*isave*dt
      end
    else
      for i in nsaved+1:input.nsave
        U[i] = U[nsaved]
        S[i] = S[nsaved]
        D[i] = D[nsaved]
        I[i] = I[nsaved]
        time[i] = i*isave*dt
      end
    end
  end

end
