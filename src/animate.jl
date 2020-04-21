
using Printf
using Plots
using ProgressMeter

function animate(traj :: Traj, input :: InputData, filename :: String;
                 size = [800,400], fps :: Int64 = 10)

  ENV["GKSwstype"]="nul"

  susc = [ count( x -> x == 0, traj.atoms[j].status) for j in 1:traj.nsteps ]
  sick = [ count( x -> x == 1, traj.atoms[j].status) for j in 1:traj.nsteps ]
  dead = [ count( x -> x == 2, traj.atoms[j].status) for j in 1:traj.nsteps ]
  immune = [ count( x -> x == 3, traj.atoms[j].status) for j in 1:traj.nsteps ]
  
  lims=[-input.side/2,input.side/2]
  
  p = Progress(traj.nsteps,1)
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
        c[j] = "white"
      elseif traj.atoms[i].status[j] == 3
        c[j] = "green"
      end
    end
  
    plot(size=size,layout=(1,2),framestyle=:box,dpi=300)
  
    plot!(xlabel=@sprintf("Time: %4i",i),subplot=1)
    scatter!(x,y,label="",color=c,xlim=lims,ylim=lims,subplot=1,markersize=2,xticks=:none,yticks=:none)
  
    time = collect(1:i)
  
    #plot!(title=@sprintf("Tempo: %4i",i),subplot=2)
    plot!(time,sick[1:i],subplot=2,linewidth=2,label="",color="red")
    plot!(time,susc[1:i],subplot=2,linewidth=2,label="",color="blue")
    plot!(time,dead[1:i],subplot=2,linewidth=2,label="",color="black")
    plot!(time,immune[1:i],subplot=2,linewidth=2,label="",color="darkgreen")
    plot!(xlim=[0,traj.nsteps],ylim=[0,traj.n],subplot=2)
    plot!(xlabel="Time",ylabel="Number of individuals",subplot=2)

    fontsize=10
    annotate!(0.05*input.nsave,input.n-0.00*input.n,text("Susceptible: $(susc[i])",:left,fontsize,:serif,:blue),subplot=2)
    annotate!(0.05*input.nsave,input.n-0.05*input.n,text("Sick: $(sick[i])",:left,fontsize,:serif,:red),subplot=2)
    annotate!(0.05*input.nsave,input.n-0.10*input.n,text("Dead: $(dead[i])",:left,fontsize,:serif,:black),subplot=2)
    annotate!(0.05*input.nsave,input.n-0.15*input.n,text("Immune: $(immune[i])",:left,fontsize,:serif,:darkgreen),subplot=2)
  
    next!(p)
  end
  
  gif(anim, filename, fps = fps)

end



