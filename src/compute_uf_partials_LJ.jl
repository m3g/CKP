# Function that updates partial force and energy vectors, used for parallel computation

function compute_uf_partials_QUAD!(it :: Int64, f :: Forces, x :: Array{Float64},
                                   i :: Int64, j :: Int64, r :: Float64,
                                   input :: InputData)

   f.upartial[it] = f.upartial[it] + input.eps*(input.sig-r)^2
   
   drdxi = -(x[j,1] - x[i,1])/r
   drdyi = -(x[j,2] - x[i,2])/r 

   fx = 2*input.eps*(input.sig-r)*drdxi
   fy = 2*input.eps*(input.sig-r)*drdyi

   f.fpartial[it][i,1] = f.fpartial[it][i,1] + fx
   f.fpartial[it][i,2] = f.fpartial[it][i,2] + fy 
   f.fpartial[it][j,1] = f.fpartial[it][j,1] - fx
   f.fpartial[it][j,2] = f.fpartial[it][j,2] - fy

end



#
# Function that computes potential energy and forces,
# using the Lennard_Jones function
#
# modifies vector f, returns u

function uf_LJ!(n :: Int64, x :: Array{Float64}, f :: Array{Float64}, input :: InputData)

  sig6 = input.sig^6
  sig12 = sig6^2
  sig66 = -6*sig6
  sig1212 = -12*sig12
  eps4 = 4*input.eps

  u = 0.
  @. f = 0.

  for i in 1:n-1
    for j in i+1:n

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,input)
      yj = image(yj,input)

      r2 = xj^2 + yj^2
      if r2 > input.cutoff^2
        continue
      end
      r = sqrt(r2)
      
      r6 = r^6
      r12 = r6^2
      r7 = r6*r
      r13 = r12*r 

      u = u + eps4*( sig12 / r12 - sig6 / r6 ) 
      
      drdxi = -xj/r
      drdyi = -yj/r 

      fx = -eps4*( (sig1212/r13) - (sig66/r7) )*drdxi
      fy = -eps4*( (sig1212/r13) - (sig66/r7) )*drdyi

      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy

    end
  end

  return u

end

function uf_LJ!(n :: Int64, atoms :: Atoms, f :: Array{Float64}, input :: InputData)

  sig6 = input.sig^6
  sig12 = sig6^2
  sig66 = -6*sig6
  sig1212 = -12*sig12
  eps4 = 4*input.eps

  x = atoms.x

  u = 0.
  @. f = 0.
  nenc = 0

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

      r2 = xj^2 + yj^2
      if r2 > input.cutoff^2
        continue  
      end
      r = sqrt(r2)
      
      r6 = r^6
      r12 = r6^2
      r7 = r6*r
      r13 = r12*r 

      u = u + eps4*( sig12 / r12 - sig6 / r6 ) 
      drdxi = -xj/r
      drdyi = -yj/r 

      fx = -eps4*( (sig1212/r13) - (sig66/r7) )*drdxi
      fy = -eps4*( (sig1212/r13) - (sig66/r7) )*drdyi

      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy

      atoms.status[i], atoms.status[j], encounter = update_status(atoms.status[i],atoms.status[j],r,input)
      if encounter
        nenc = nenc + 1
      end

    end
  end

  return u, nenc

end

