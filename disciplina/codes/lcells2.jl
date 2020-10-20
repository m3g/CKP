using Plots
using Random
Random.seed!(9)

function square(c,side)
  x = [ c[1]-side/2, c[1]+side/2, c[1]+side/2, c[1]-side/2, c[1]-side/2]  
  y = [ c[2]-side/2, c[2]-side/2, c[2]+side/2, c[2]+side/2, c[2]-side/2]
  return x, y
end

plot()

x,y=square([5,5],2)
plot!(x,y,seriestype=[:shape],
      linewidth=2,fillalpha=0.05,color="green",label="")

x,y=square([5,5],6)
plot!(x,y,seriestype=[:shape],
      linewidth=2,fillalpha=0.05,color="orange",label="")

lines = collect(2:2:8)
vline!(lines,color="gray",label="",style=:dash)
hline!(lines,color="gray",label="",style=:dash)

px = [ 0.1 + 9.8*rand() for i in 1:100 ]
py = [ 0.1 + 9.8*rand() for i in 1:100 ]
scatter!(px,py,label="",alpha=0.05,color="blue")

using LaTeXStrings

fontsize=8
annotate!(3,3,text("(i-1,j-1)",fontsize,:Courier))
annotate!(5,3,text("(i-1,j)",fontsize,:Courier))
annotate!(7,3,text("(i-1,j+1)",fontsize,:Courier))

annotate!(3,5,text("(i,j-1)",fontsize,:Courier))
annotate!(5,5,text("(i,j)",fontsize,:Courier))
annotate!(7,5,text("(i,j+1)",fontsize,:Courier))

annotate!(3,7,text("(i+1,j-1)",fontsize,:Courier))
annotate!(5,7,text("(i+1,j)",fontsize,:Courier))
annotate!(7,7,text("(i+1,j+1)",fontsize,:Courier))

plot!(size=(400,400), 
      xlim=(1.3,8.7),xticks=:none,
      ylim=(1.3,8.7),yticks=:none,
      framestyle=:box,
      xlabel="x",ylabel="y",grid=false)
savefig("lcells2.pdf")
