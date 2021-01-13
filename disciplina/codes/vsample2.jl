using Plots
using LaTeXStrings

# Probability of v±dv
p(v;m=1.,R=8.3145,T=298.15) = m/(R*T) * v * exp(-m*v^2/(2R*T)) 

# Probability of v < x, given m and T
pcum(x;m = 1., T = 298.15, R = 8.3145) = -exp(-m*x^2/(2*R*T)) + 1

# Inverse Cumulative Probability of v < x, given m and T
pinv(x;m=1., T=298.15, R=8.3145) = sqrt(-(2*R*T/m)*log(1-x))

# Start plot
plot(layout=(1,2))

# Collect x
x = collect(0:0.1:200)

# Set y with m = 1, T = 298.15K, R = 8.3145 J/Kmol
y = pcum.(x)

# plot
plot!(x,y,label="",subplot=1)
plot!(xlabel=L"x / m s^{-1}",ylabel=L"p~(v<x)",subplot=1)

xl = 70
yl = pcum(xl)
plot!([-10,xl],[yl,yl],label="",color="black",linestyle=:dash,subplot=1)
plot!([xl,xl],[-10,yl],label="",color="black",linestyle=:dash,subplot=1)
scatter!([xl],[yl],label="",color="black",markerstyle=:circle,subplot=1)

annotate!(xl,-0.07,text(L"v~(p_x)",8),subplot=1)
annotate!(-12,yl,text(L"p_x",8),subplot=1)

plot!(xlim=[0,200],ylim=[0,1],subplot=1)

# Sample points from inverse of cumulative distribution
N = 20_000
x = rand(N)
histogram!(pinv.(x),alpha=0.3,label="",normalize=:probability,bins=1:2:200,subplot=2)

# Plot distribution
x = collect(0:2:200)
plot!(x,2*p.(x),label="",linewidth=2,subplot=2)

plot!(xlabel=L"v / ms^{-1}",ylabel=L"p~(v)dv",subplot=2)
plot!(framestyle=:box,subplot=2)

plot!(size=(800,400),framestyle=:box)

savefig("./vsample.pdf")







