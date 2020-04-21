#
# Update positions, simple integrator
#

function update_positions!( atoms :: Atoms, f :: Array{Float64}, v :: Array{Float64}, input :: InputData )
  n = input.n
  dt = input.dt
  x = atoms.x
  for i in 1:n
    if atoms.status[i] == 2
      continue  
    end
    x[i,1] = image(x[i,1] + v[i,1]*dt + 0.5*f[i,1]*(dt^2),input)
    x[i,2] = image(x[i,2] + v[i,2]*dt + 0.5*f[i,2]*(dt^2),input)
  end
end
