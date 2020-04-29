#
# Function that obtains the best fit between a SIRD simulation and trajectory
# data obtained from simulations
#

using Optim

# The two possible functions to be fited: all data or one of the curves, defined by ipop

function fit(md_input :: MDInput, md_traj :: MDTraj; 
             ipop :: Int64 = -1, 
             bounded :: Bool = true, lower :: Vector{Float64} = zeros(4), upper :: Vector{Float64} = [10.,10.,10.,10.])

  sird_input = SIRDInput(tmax=md_input.tmax,nsave=md_traj.nsteps,
                         Si=md_input.Si,
                         print=false)
  sird_traj = SIRDTraj(sird_input)

  k0 = [ rand()*sird_input.kc, 
         rand()*sird_input.kd, 
         rand()*sird_input.ki, 
         rand()sird_input.kiu ]

  fall(k0 :: Vector{Float64}) = fiteval!( k0, md_traj, sird_input, sird_traj )
  fpop(k0 :: Vector{Float64}) = fiteval!( k0, md_traj, sird_input, sird_traj, ipop )

  if bounded
    if ipop == -1
      x = Optim.optimize( fall, lower, upper, k0, Fminbox(NelderMead()) ) 
    else
      x = Optim.optimize( fpop, lower, upper, k0, Fminbox(NelderMead()) ) 
    end
  else
    if ipop == -1
      x = Optim.optimize( fall, k0, NelderMead() ) 
    else
      x = Optim.optimize( fpop, k0, NelderMead() ) 
    end
  end

  # Perform simulation with optimal parameters

  sird_input = SIRDInput( kc = x.minimizer[1], 
                          kd = x.minimizer[2],
                          ki = x.minimizer[3],
                          kiu = x.minimizer[4],
                          tmax = md_input.tmax, 
                          nsave = md_traj.nsteps )
  if ipop == -1
    fitresult = fiteval!(x.minimizer,md_traj,sird_input,sird_traj)
  else
    fitresult = fiteval!(x.minimizer,md_traj,sird_input,sird_traj,ipop)
  end

  println("-------------------------------------------------------")
  println(" Fitting result: ") 
  println(" Error: ", fitresult )   
  println(" Best ks found: ")
  println(" kc = ", sird_input.kc)
  println(" kd = ", sird_input.kd)
  println(" ki = ", sird_input.ki)
  println(" kiu = ", sird_input.kiu)
  println("-------------------------------------------------------")

  return sird_input, sird_traj

end







