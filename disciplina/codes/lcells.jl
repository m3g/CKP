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
      linewidth=2,fillalpha=0.2,color="green",label="")

x,y=square([5,5],6)
plot!(x,y,seriestype=[:shape],
      linewidth=2,fillalpha=0.1,color="orange",label="")

lines = collect(2:2:8)
vline!(lines,color="gray",label="")
hline!(lines,color="gray",label="")

px = [ 0.1 + 9.8*rand() for i in 1:100 ]
py = [ 0.1 + 9.8*rand() for i in 1:100 ]
scatter!(px,py,label="",alpha=0.2,color="blue")

for i in 1:5
  for j in 1:5
    annotate!(2*j-1,2*i-1,text("($i,$j)"))
  end
end

plot!(size=(400,400), 
      xlim=(0,10),
      ylim=(0,10),
      framestyle=:box,
      xlabel="x",ylabel="y",grid=false)
savefig("lcells.pdf")
