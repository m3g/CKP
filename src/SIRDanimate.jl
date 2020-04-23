#
# Plot the results of a SIRD simulation
#

using Plots

function plot( input :: SIRDInput, traj :: SIRDTraj ; 
              size=(400,400) )

  time = traj.time
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  nsteps = traj.nsteps

  xmax = time[nsteps]

  plot(size=(400,400))
  plot!(time,U,label="Susceptible: $(@sprintf("%2.1f",U[n]*100))%",linewidth=2,color=:blue)
  plot!(time,S,label="Sick: $(@sprintf("%2.1f",D[n]*100))%",linewidth=2,color=:red)
  plot!(time,I,label="Immune: $(@sprintf("%2.1f",I[n]*100))%",linewidth=2,color=:darkgreen)
  plot!(time,D,label="Dead: $(@sprintf("%2.1f",M[n]*100))%",linewidth=2,color=:black)
  plot!(xlabel="time")
  plot!(ylabel="Fraction of the population")
  plot!(xlim=[0,xmax,ylim=[0,1])

  plot!(rectangle((7/20)*xmax, # xlength
                  0.210*traj.n, #ylength
                  0, #xmin
                  0.815*traj.n, #ymin
                  ), opacity=0.9,label="",color=:white)
  plot!(rectangle((9/20)*xmax, # xlength
                  0.110*traj.n, #ylength
                  (11/20)*xmax, #xmin
                  0.910*traj.n, #ymin
                  ), opacity=0.9,label="",color=:white)

  fontsize=8
  annotate!(0.05*xmax,input.n-0.00*input.n,text("Susceptible: $(U[i])",:left,fontsize,:serif,:blue))
  annotate!(0.05*xmax,input.n-0.05*input.n,text("Sick: $(S[i])",:left,fontsize,:serif,:red))
  annotate!(0.05*xmax,input.n-0.10*input.n,text("Dead: $(D[i])",:left,fontsize,:serif,:black))
  annotate!(0.05*xmax,input.n-0.15*input.n,text("Immune: $(I[i])",:left,fontsize,:serif,:darkgreen))
  annotate!(0.98*xmax,input.n-0.00*input.n,text("kc = $kc ; kd = $kd",:right,fontsize,:serif,:black))
  annotate!(0.98*xmax,input.n-0.05*input.n,text("ki = $ki ; kis = $kis",:right,fontsize,:serif,:black))

    next!(p)

  end
  
  gif(anim, filename, fps = fps)

end






