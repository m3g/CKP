using Plots
p = [ 10*rand(2) for i in 1:100 ]
x = [ p[i][1] for i in 1:100 ]
y = [ p[i][2] for i in 1:100 ]
scatter(x,y,
        xlabel="x",ylabel="y",label="",
        xlim=[-15,25],ylim=[-15,25],
        size=(400,400),framestyle=:box)
savefig("pbc1.pdf")



