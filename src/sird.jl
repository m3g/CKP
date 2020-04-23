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
error(U,S,D,I) = abs(1. - (U + S + D + I))

function sird(input :: SIRDInput)

  traj = SIRDTraj(input)

  # To clear out the code
  dt = input.dt
  nsteps = traj.nsteps
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  time = traj.time

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
  for i in 2:nsteps
    time[i] = i*dt
    U[i] = U[i-1] + dUdt(U[i-1],S[i-1],I[i-1],input)*dt
    S[i] = S[i-1] + dSdt(U[i-1],S[i-1],input)*dt
    D[i] = D[i-1] + dDdt(S[i-1],input)*dt
    I[i] = I[i-1] + dIdt(S[i-1],I[i-1],input)*dt
    # check if epidemics ended
    if S[i] < input.tol
      nlast = i
      break
    end
    # check if integration is going fine
    err = error(U[i],S[i],D[i],I[i])
    if err > input.err
      println(" SIRD: Integration error too large at step: ", i," error = ",err)
      nlast = i
      break
    end
  end
  println(" Epidemics ended at step = ", nlast)
  
  # Filling up vector up to the end, if the trajectory ended before
  if nlast < nsteps
    for i in nlast+1:nsteps
      U[i] = U[nlast]
      S[i] = S[nlast]
      D[i] = D[nlast]
      I[i] = I[nlast]
      time[i] = i*dt
    end
  end
  return traj

end
