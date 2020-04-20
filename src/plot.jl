
ENV["GKSwstype"]="nul"
using Printf
using Plots
using ProgressMeter

healthy = [ count( x -> x == 0, traj.atoms[j].status) for j in 1:traj.nsteps ]
sick = [ count( x -> x == 1, traj.atoms[j].status) for j in 1:traj.nsteps ]
dead = [ count( x -> x == 2, traj.atoms[j].status) for j in 1:traj.nsteps ]
immune = [ count( x -> x == 3, traj.atoms[j].status) for j in 1:traj.nsteps ]

anim = @animate for i in 1:traj.nsteps

  x = traj.atoms[i].x[:,1];
  y = traj.atoms[i].x[:,2];
  c = Vector{String}(undef,traj.n)
  for j in 1:traj.n
    if traj.atoms[i].status[j] == 0
      c[j] = "blue"
    elseif traj.atoms[i].status[j] == 1
      c[j] = "red"
    elseif traj.atoms[i].status[j] == 2
      c[j] = "black"
    elseif traj.atoms[i].status[j] == 3
      c[j] = "green"
    end
  end

  plot(size=(800,400),layout=(1,2),framestyle=:box)

  plot!(title=@sprintf("Tempo: %4i",i),subplot=1)
  scatter!(x,y,label="",color=c,xlim=[-50,50],ylim=[-50,50],subplot=1)

  time = collect(1:i)

  plot!(title=@sprintf("Tempo: %4i",i),subplot=2)
  plot!(time,sick[1:i],subplot=2,linewidth=2,label="Sick",color="red")
  plot!(time,healthy[1:i],subplot=2,linewidth=2,label="Healthy",color="blue")
  plot!(time,dead[1:i],subplot=2,linewidth=2,label="Dead",color="black")
  plot!(time,immune[1:i],subplot=2,linewidth=2,label="Immune",color="green")
  plot!(xlim=[0,traj.nsteps],ylim=[0,traj.n],subplot=2)

end

gif(anim, "animation.gif", fps = 10)

