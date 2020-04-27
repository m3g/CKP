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

dUdt(U,S,I,input) = -input.kc*U*S + input.kiu*I
dSdt(U,S,input) = input.kc*U*S - (input.kd+input.ki)*S
dDdt(S,input) = input.kd*S
dIdt(S,I,input) = input.ki*S - input.kiu*I

# error
sird_error(U,S,D,I) = abs(1. - (U + S + D + I))

function sird(input :: SIRDInput)

  traj = SIRDTraj(input)

  # To clear out the code
  dt = input.dt
  nsteps = round(Int64,input.tmax/dt)
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  time = traj.time
  isave = round(Int64,nsteps/input.nsave)

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
    Uc = Up + dUdt(Up,Sp,Ip,input)*dt
    Sc = Sp + dSdt(Up,Sp,input)*dt
    Dc = Dp + dDdt(Sp,input)*dt
    Ic = Ip + dIdt(Sp,Ip,input)*dt
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
      println(" SIRD: Integration error too large at step: ", i," error = ",err)
      nlast = i
      break
    end
  end
  println(" Epidemics ended at step = ", nlast)
  println(" Last step saved = ", nsaved, " time = ", time[nsaved])
  
  # Filling up vector up to the end, if the trajectory ended before
  if nsaved < input.nsave
    for i in nsaved+1:input.nsave
      U[i] = U[nsaved]
      S[i] = S[nsaved]
      D[i] = D[nsaved]
      I[i] = I[nsaved]
      time[i] = i*isave*dt
    end
  end
  return traj

end
