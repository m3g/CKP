#
# Function that computes the forces and potential energy,
# using a simple quadratic energy function
#
# modifies vector f, returns u

#
# Version that receives the coordinates of the atoms only, used in equilibration
# -> does not update contaminations or count encounters
#

function uf_QUAD!(n :: Int64, x :: Array{Float64}, f :: Forces, input :: Input)

  resetForces!(f)

  Threads.@threads for i in 1:n-1
    it = Threads.threadid()
    for j in i+1:n
      xj = image(x[j,1] - x[i,1],input)
      yj = image(x[j,2] - x[i,2],input)
      r2 = xj^2 + yj^2
      if r2 < f.cutoff2 && r2 < f.sig2
        r = sqrt(r2)
        compute_uf_partials_QUAD!(it,f,i,j,xj,yj,r,input)
      end
    end
  end

  u = reduceForces!(f)
  return u

end

#
# Version that receives the Atoms structure, to compute the number of encounters
# -> used in the production simulation, to compute the contamination
#

function uf_QUAD!(n :: Int64, atoms :: Atoms, f :: Forces, input :: Input)

  x = atoms.x
  resetForces!(f)

  Threads.@threads for i in 1:n-1
    it = Threads.threadid()

    if atoms.status[i] == 2 
      continue
    end

    for j in i+1:n

      if atoms.status[j] == 2 
        continue
      end

      xj = image(x[j,1] - x[i,1],input)
      yj = image(x[j,2] - x[i,2],input)
      r2 = xj^2 + yj^2
      if r2 < f.cutoff2 
        r = sqrt(r2)
        if r2 < f.sig2
          compute_uf_partials_QUAD!(it,f,i,j,xj,yj,r,input)
        end
        atoms.status[i], atoms.status[j], encounter = update_status(atoms.status[i],atoms.status[j],r,input)
        if encounter
          f.nenc_partial[it] = f.nenc_partial[it] + 1
        end
      end

    end

  end

  u = reduceForces!(f)
  return u, sum(f.nenc_partial)

end

