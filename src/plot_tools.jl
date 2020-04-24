
# function to set y annotations with equal displacement
function yd!(y,d)
  y[1] = y[1] - d
  return y[1]
end

# function to draw a rectangle
rectangle(xmin, xmax, ymin, ymax) = Shape(xmin .+ [0,xmax-xmin,xmax-xmin,0], ymin .+ [0,0,ymax-ymin,ymax-ymin])

