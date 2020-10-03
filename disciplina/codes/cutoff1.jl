using Plots
U(r,eps,sig) = 4*eps*((sig/r)^12 - (sig/r)^6)
# r vector between 0.01 and 15.
r = collect(0.4:0.01:2.5)
# compute U for every r
eps = 2. ; sig = 0.5 ;
u = [ U(x,eps,sig) for x in r ]
plot(r,u,label="",xlabel="r",ylabel="U(r)",
     ylim=[-2.5,10],framestyle=:box,linewidth=2,
     size=(400,300))
savefig("./cutoff1.pdf")
