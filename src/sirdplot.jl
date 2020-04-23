#
# Plot the results of a SIRD simulation
#

using Plots

function sirdplot( input :: SIRDInput, traj :: SIRDTraj, filename :: String; 
                   size=(400,400) )

  time = traj.time
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  nsteps = traj.nsteps

  xmax = time[nsteps]

  plot(size=(400,400),legendtitle="Final result:",framestyle=:box,legend=:topleft)
  plot!(time,U,label="Susceptible: $(@sprintf("%2.1f",U[nsteps]*100))%",linewidth=2,color=:blue)
  plot!(time,S,label="Sick: $(@sprintf("%2.1f",S[nsteps]*100))%",linewidth=2,color=:red)
  plot!(time,I,label="Immune: $(@sprintf("%2.1f",I[nsteps]*100))%",linewidth=2,color=:darkgreen)
  plot!(time,D,label="Dead: $(@sprintf("%2.1f",D[nsteps]*100))%",linewidth=2,color=:black)
  plot!(xlabel="time")
  plot!(ylabel="Fraction of the population")
  plot!(xlim=[0,xmax],ylim=[0,1])

  plot!(rectangle((9/20)*xmax, # xlength
                  0.110*traj.nsteps, #ylength
                  (11/20)*xmax, #xmin
                  0.910*traj.nsteps, #ymin
                  ), opacity=0.9,label="",color=:white)

  fontsize=8
  annotate!(0.98*xmax,1-0.00,text("kc = $(input.kc) ; kd = $(input.kd)",:right,fontsize,:serif,:black))
  annotate!(0.98*xmax,1-0.05,text("ki = $(input.ki) ; kiu = $(input.kiu)",:right,fontsize,:serif,:black))

  savefig(filename)

end






