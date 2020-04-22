# Function that computes the squared distance between two atoms

function compute_r2(i,j,x,input)
  xj = x[j,1] - x[i,1]
  yj = x[j,2] - x[i,2]
  xj = image(xj,input)
  yj = image(yj,input)
  r2 = xj^2 + yj^2
  return r2
end

