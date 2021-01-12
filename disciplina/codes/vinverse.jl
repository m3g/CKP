
using Plots
using LaTeXStrings

# Probability of v < x, given m and T
p(x;m = 1., T = 298.15, R = 8.3145) = -exp(-m*x^2/(2*R*T)) + 1

# Collect x
x = collect(0:0.1:200)

# Set y with m = 1, T = 298.15K, R = 8.3145 J/Kmol
y = p.(x)

# plot
plot(x,y,label="")
plot!(xlabel=L"x / m s^{-1}",ylabel=L"p~(v<x)")

xl = 70
yl = p(xl)
plot!([-10,xl],[yl,yl],label="",color="black",linestyle=:dash)
plot!([xl,xl],[-10,yl],label="",color="black",linestyle=:dash)
scatter!([xl],[yl],label="",color="black",markerstyle=:circle)

annotate!(xl,-0.07,text(L"v~(p_x)",8))
annotate!(-12,yl,text(L"p_x",8))

plot!(xlim=[0,200],ylim=[0,1])

plot!(size=(400,400),framestyle=:box)

savefig("vinverse.pdf")





