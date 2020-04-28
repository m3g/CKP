#
# Function that computes the fit (least square sense) of a SIRD simulation to the 
# trajectory data
#
# This function modifies the sird_traj data of input, which is to be taken as an
# auxiliary vector only
#

function fiteval!(x0 :: Vector{Float64}, md_traj :: MDTraj, 
                  sird_input :: SIRDInput, sird_traj :: SIRDTraj, ipop :: Int64)

  # perform SIRD simulation
  sird!(x0,sird_input,sird_traj)

  # Which data will be used
  if ipop == 0  # Susceptible
    md = md_traj.U
    sird = sird_traj.U 
  elseif ipop == 1 # Sick
    md = md_traj.S
    sird = sird_traj.S 
  elseif ipop == 2 # Dead
    md = md_traj.D
    sird = sird_traj.D 
  elseif ipop == 3 # Immune
    md = md_traj.I
    sird = sird_traj.I 
  end

  fit = 0.
  for i in 1:md_traj.nsteps
    fit = fit + (md[i]-sird[i])^2
  end
  fit = sqrt(fit/md_traj.nsteps)

  return fit

end


