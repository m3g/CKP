#
# Subroutine that computes the force
#
# modifies vector f

function force!(n :: Int64, x :: Array{Float64}, f :: Array{Float64}, input :: InputData)

  for i in 1:n
    f[i,1] = 0.
    f[i,2] = 0.
  end

  for i in 1:n-1
    for j in i+1:n

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,input)
      yj = image(yj,input)

      r = sqrt(xj^2 + yj^2)
      
      drdxi = -xj/r
      drdyi = -yj/r 

      fx = -4.0*input.eps*( (-12.0*input.sig^12/r^13) - (-6.0*input.sig^6/r^7) )*drdxi
      fy = -4.0*input.eps*( (-12.0*input.sig^12/r^13) - (-6.0*input.sig^6/r^7) )*drdyi

      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy

    end
  end

end


function force!(n :: Int64, atoms :: Atoms, f :: Array{Float64}, input :: InputData)

  x = atoms.x

  for i in 1:n
    f[i,1] = 0.
    f[i,2] = 0.
  end

  for i in 1:n-1
    if atoms.status[i] == 2 
      continue
    end
    for j in i+1:n
      if atoms.status[j] == 2 
        continue
      end

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,input)
      yj = image(yj,input)

      r = sqrt(xj^2 + yj^2)
      
      drdxi = -xj/r
      drdyi = -yj/r 

      fx = -4.0*input.eps*( (-12.0*input.sig^12/r^13) - (-6.0*input.sig^6/r^7) )*drdxi
      fy = -4.0*input.eps*( (-12.0*input.sig^12/r^13) - (-6.0*input.sig^6/r^7) )*drdyi

      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy

    end
  end

end

