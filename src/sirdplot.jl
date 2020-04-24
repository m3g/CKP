#
# Plot the results of a SIRD simulation
#

using Plots

function sirdplot( input :: SIRDInput, traj :: SIRDTraj, filename :: String; 
                   size=(400,400) )

  ENV["GKSwstype"]="nul"


  time = traj.time
  U = traj.U
  S = traj.S
  D = traj.D
  I = traj.I
  nsteps = traj.nsteps

  xmax = time[nsteps]
  xmin = time[1]

  plot(size=(400,400),framestyle=:box)
  plot!(time,U,label="",linewidth=2,color=:blue)
  plot!(time,S,label="",linewidth=2,color=:red)
  plot!(time,I,label="",linewidth=2,color=:darkgreen)
  plot!(time,D,label="",linewidth=2,color=:black)
  plot!(xlabel="time")
  plot!(ylabel="Fraction of the population")
  plot!(xlim=[0,xmax],ylim=[0,1])

  plot!(rectangle(-0.05,80,0.76,1.02), opacity=0.9,label="",color=:white)

  fontsize=8
  x = 0.01*(xmax-xmin) + xmin
  d = 0.05 ; y = [ 0.99 + d ] 
  annotate!(x,yd!(y,d),text("Final data:",:left,fontsize,:serif,:black))
  annotate!(x,yd!(y,d),text("Susceptible: $(@sprintf("%2.1f",U[nsteps]*100))%",:left,fontsize,:serif,:blue))
  annotate!(x,yd!(y,d),text("Sick: $(@sprintf("%2.1f",S[nsteps]*100))%",:left,fontsize,:serif,:red))
  annotate!(x,yd!(y,d),text("Immune: $(@sprintf("%2.1f",I[nsteps]*100))%",:left,fontsize,:serif,:darkgreen))
  annotate!(x,yd!(y,d),text("Dead: $(@sprintf("%2.1f",D[nsteps]*100))%",:left,fontsize,:serif,:black))

  plot!(rectangle(88, 202, 0.915, 1.02), opacity=0.9,label="",color=:white)

  x = 0.98*(xmax-xmin)+xmin
  d = 0.05 ; y = [ 0.99 + d ] 
  s = @sprintf("kc = %7.5f ; kd = %7.5f",input.kc,input.kd)
  annotate!(x,yd!(y,d),text(s,:right,fontsize,:serif,:black))
  s = @sprintf("ki = %7.5f ; kiu = %7.5f",input.ki,input.kiu)
  annotate!(x,yd!(y,d),text(s,:right,fontsize,:serif,:black))

  savefig(filename)

end






