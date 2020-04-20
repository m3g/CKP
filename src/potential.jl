#
# Function that computes the potential energy
#

function potential(n :: Int64, x :: Array{Float64}, input :: InputData)
  potential = 0.0
  for i in 1:n-1
    for j in i+1:n 
      xj = image(x[j,1] - x[i,1],input)
      yj = image(x[j,2] - x[i,2],input)
      r = sqrt(xj^2 + yj^2)
      potential = potential + 4*input.eps*( input.sig^12 / r^12 - input.sig^6 / r^6 )
    end
  end
  return potential
end
