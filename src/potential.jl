#
# Function that computes the potential energy
#

potential(n,x) = potential(n,x,ff)

function potential(n,x, ff :: ForceField)
  potential = 0.0
  for i in 1:n-1
    for j in i+1:n 
      xj = image(x[j,1] - x[i,1],ff)
      yj = image(x[j,2] - x[i,2],ff)
      r = sqrt(xj^2 + yj^2)
      potential = potential + 4*ff.eps*( ff.sig^12 / r^12 - ff.sig^6 / r^6 )
    end
  end
  return potential
end
