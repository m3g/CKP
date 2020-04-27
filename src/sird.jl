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
simrd_error(U,S,D,I) = abs(1. - (U + S + D + I))

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

  # Initial populations
  S[1] = input.Si
  D[1] = input.Di
  I[1] = input.Ii
  if S[1] + D[1] + I[1] > 1.
    error("Sum of sick, dead, and immune cannot be greater than 1.")
  end
  U[1] = 1. - (S[1]+D[1]+I[1])
  time[1] = 0.
   
  # Running simulation
  nlast = nsteps
  # Current values
  Uc = U[1]
  Sc = S[1]
  Dc = D[1]
  Ic = I[1]
  is = 1
  for i in 2:nsteps
    # Previous values
    Up = Uc
    Sp = Sc
    Dp = Dc
    Ip = Ic
    # Update populations
    Uc = Up + dUdt(Up,Sp,Ip,input)*dt
    Sc = Sp + dSdt(Up,Sp,input)*dt
    Dc = Dp + dDdt(Sp,input)*dt
    Ic = Ip + dIdt(Sp,Ip,input)*dt
    # Save data if required at this step
    if i%isave == 0
      is = is + 1
      U[is] = Uc
      S[is] = Sc
      D[is] = Dc
      I[is] = Ic
      time[is] = (i-1)*dt
    end
    # check if epidemics ended
    if Sc < input.tol
      nlast = i
      break
    end
    # check if integration is going fine
    err = simrd_error(Uc,Sc,Dc,Ic)
    if err > input.err
      println(" SIRD: Integration error too large at step: ", i," error = ",err)
      nlast = i
      break
    end
  end
  println(" Epidemics ended at step = ", nlast)
  println(" Last step saved = ", is, " time = ", time[is])
  
  # Filling up vector up to the end, if the trajectory ended before
  if is < input.nsave
    for i in is:input.nsave
      U[i] = U[is]
      S[i] = S[is]
      D[i] = D[is]
      I[i] = I[is]
      time[i] = (i-1)*isave*dt
    end
  end
  return traj

end
