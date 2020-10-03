using Plots

function square(c,side)
  x = [ c[1]-side/2, c[1]+side/2, c[1]+side/2, c[1]-side/2, c[1]-side/2]  
  y = [ c[2]-side/2, c[2]-side/2, c[2]+side/2, c[2]+side/2, c[2]-side/2]
  return x, y
end

# Generate points
p = [ 10*rand(2) for i in 1:100 ]

# Plot a square around point 1
plot(square(p[1],10),seriestype=[:shape],
            linewdith=0.5,fillalpha=0.2,
            color="green",label="")

# Images
images = [ -2, -1, 0, 1, 2 ]
for j in images, k in images
  if j != 0 || k != 0 # Do not plot (0,0) again
    xim = [ p[i][1] + j*10 for i in 1:100 ]
    yim = [ p[i][2] + k*10 for i in 1:100 ]
    scatter!(xim,yim,color="orange",label="")
  end
end

# Central plot
x = [ p[i][1] for i in 1:100 ]
y = [ p[i][2] for i in 1:100 ]
scatter!(x,y,xlabel="x",ylabel="y",label="",color="lightblue")

# Mark point one as red
scatter!([p[1][1]],[p[1][2]],color="red",label="",size=4)

plot!(xlim=[-15,25],ylim=[-15,25],
      size=(400,400),framestyle=:box)

hline!(10*images,color="black",label="") # horizontal lines
vline!(10*images,color="black",label="") # vertical lines

savefig("pbc2.pdf")
