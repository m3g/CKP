#
# Function that computes the potential energy
#

r2(x,y) = x^2 + y^2
upair(x :: Float64, y :: Float64, r2, input) = 4*input.eps*( input.sig^12 / r2^6 - input.sig^6 / r2^3 )

function potential(n :: Int64, x :: Array{Float64}, input :: InputData)
  potential = 0.0
  for i in 1:n-1
    for j in i+1:n 
      xj = image(x[j,1] - x[i,1],input)
      yj = image(x[j,2] - x[i,2],input)
      d2 = r2(xj,yj)
      if d2 < input.cutoff^2
        potential = potential + upair(xj,yj,d2,input)
      end
    end
  end
  return potential
end

function potential(n :: Int64, atoms :: Atoms, input :: InputData)
  x = atoms.x
  status = atoms.status
  potential = 0.0
  for i in 1:n-1
    if status[i] == 2
      continue
    end
    for j in i+1:n 
      if status[j] == 2
        continue
      end
      xj = image(x[j,1] - x[i,1],input)
      yj = image(x[j,2] - x[i,2],input)
      d2 = r2(xj,yj)
      if d2 < input.cutoff^2
        potential = potential + upair(xj,yj,d2,input)
      end
      # Check contatmination
      if  ( status[i] == 1 || status[j] == 1 ) &&
          ( status[i] < 3 && status[j] < 3 ) # 3 and 4 are dead and immune
        # if the distance is smaller than the x-section
        if d2 < input.xsec^2  
          if rand() < input.pcont
            status[i] = 1
            status[j] = 1
          end
        end
      end
    end
  end
  return potential
end
