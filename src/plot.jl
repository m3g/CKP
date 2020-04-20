
ENV["GKSwstype"]="nul"
using Printf
using Plots
using ProgressMeter

plot(framestyle=:box)

anim = @animate for i in 1:traj.nsteps
  x = traj.atoms[i].x[:,1];
  y = traj.atoms[i].x[:,2];
  c = traj.atoms[i].status;
  plot(title=@sprintf("Tempo: %4i",i),size=(800,800))
  scatter!(x,y,label="",color=c,xlim=[-50,50],ylim=[-50,50])
end

gif(anim, "animation.gif", fps = 10)

