#
# Subroutine that computes the force
#
# modifies vector f, returns u

function forces_and_energy_simple!(n :: Int64, x :: Array{Float64}, f :: Array{Float64}, input :: InputData)

  u = 0.

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

      d2 = xj^2 + yj^2
      if d2 > input.cutoff^2
        continue
      end
      d = sqrt(d2)
      
      if d < input.sig

        u = u + input.eps*(d-input.sig)^2
      
        drdxi = -xj/d
        drdyi = -yj/d 

        fx = 2*input.eps*(d-input.sig)*drdxi
        fy = 2*input.eps*(d-input.sig)*drdyi

        f[i,1] = f[i,1] + fx
        f[i,2] = f[i,2] + fy 
        f[j,1] = f[j,1] - fx
        f[j,2] = f[j,2] - fy

      end

    end
  end

  return u

end

function forces_and_energy_simple!(n :: Int64, atoms :: Atoms, f :: Array{Float64}, input :: InputData)

  x = atoms.x

  u = 0.

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

      d2 = xj^2 + yj^2
      if d2 > input.cutoff^2
        continue  
      end
      d = sqrt(d2)

      if d < input.sig

        u = u + input.eps*(d-input.sig)^2
      
        drdxi = -xj/d
        drdyi = -yj/d 

        fx = 2*input.eps*(d-input.sig)*drdxi
        fy = 2*input.eps*(d-input.sig)*drdyi

        f[i,1] = f[i,1] + fx
        f[i,2] = f[i,2] + fy 
        f[j,1] = f[j,1] - fx
        f[j,2] = f[j,2] - fy

      end

      atoms.status[i], atoms.status[j] = update_status(atoms.status[i],atoms.status[j],d,input)

    end
  end

  return u

end

