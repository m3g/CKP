#
# Plot the results of a SIRD simulation
#

using Plots

function fitplot( md_input :: MDInput, md_traj :: MDTraj,
                  sird_input :: SIRDInput, sird_traj :: SIRDTraj, 
                  filename :: String; 
                  size=(400,400) )

  ENV["GKSwstype"]="nul"

  time = sird_traj.time
  sU = sird_traj.U
  sS = sird_traj.S
  sD = sird_traj.D
  sI = sird_traj.I
  nsteps = sird_traj.nsteps

  mU = md_traj.U
  mS = md_traj.S
  mD = md_traj.D
  mI = md_traj.I

  xmin = time[1]
  xmax = time[nsteps]

  plot(size=(400,400),framestyle=:box)

  scatter!(time,mU,label="",color=:blue     , marker = (:circle, 3, 1.0, :blue, stroke(0.1, 0.5, :black))) 
  scatter!(time,mS,label="",color=:red      , marker = (:circle, 3, 1.0, :red, stroke(0.1, 0.5, :black))) 
  scatter!(time,mI,label="",color=:darkgreen, marker = (:circle, 3, 1.0, :darkgreen, stroke(0.1, 0.5, :black))) 
  scatter!(time,mD,label="",color=:black    , marker = (:circle, 3, 1.0, :black, stroke(0.1, 0.5, :black)))

  plot!(time,sU,label="",linewidth=2,color=:blue)
  plot!(time,sS,label="",linewidth=2,color=:red)
  plot!(time,sI,label="",linewidth=2,color=:darkgreen)
  plot!(time,sD,label="",linewidth=2,color=:black)

  plot!(xlabel="time")
  plot!(ylabel="Fraction of the population")
  plot!(xlim=[0,xmax],ylim=[0,1])

  plot!(rectangle(-0.01*xmax,0.4*xmax,0.76,1.02), opacity=0.9,label="",color=:white)

  fontsize=8
  x = 0.01*(xmax-xmin) + xmin
  d = 0.05 ; y = [ 0.99 + d ] 
  annotate!(x,yd!(y,d),text("Final data:",:left,fontsize,:serif,:black))
  annotate!(x,yd!(y,d),text("Susceptible: $(@sprintf("%2.1f",sU[nsteps]*100))%",:left,fontsize,:serif,:blue))
  annotate!(x,yd!(y,d),text("Sick: $(@sprintf("%2.1f",sS[nsteps]*100))%",:left,fontsize,:serif,:red))
  annotate!(x,yd!(y,d),text("Immune: $(@sprintf("%2.1f",sI[nsteps]*100))%",:left,fontsize,:serif,:darkgreen))
  annotate!(x,yd!(y,d),text("Dead: $(@sprintf("%2.1f",sD[nsteps]*100))%",:left,fontsize,:serif,:black))

  plot!(rectangle(0.44*xmax, 1.01*xmax, 0.915, 1.02), opacity=0.9,label="",color=:white)

  x = 0.98*(xmax-xmin)+xmin
  d = 0.05 ; y = [ 0.99 + d ] 
  s = @sprintf("kc = %7.5f ; kd = %7.5f",sird_input.kc,sird_input.kd)
  annotate!(x,yd!(y,d),text(s,:right,fontsize,:serif,:black))
  s = @sprintf("ki = %7.5f ; kiu = %7.5f",sird_input.ki,sird_input.kiu)
  annotate!(x,yd!(y,d),text(s,:right,fontsize,:serif,:black))

  savefig(filename)

end






