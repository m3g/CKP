#
# update velocities using berendsen bath
#

function update_velocities!(v :: Array{Float64} ,kavg :: Float64, 
                            f :: Array{Float64}, flast :: Array{Float64},
                            input :: Input)

  n = input.n
  dt = input.dt
  vx = 0.
  vy = 0.
  lambda = sqrt( 1 + (dt/input.tau)*(input.kavg_target/kavg-1) )
  for i in 1:n
    v[i,1] = v[i,1]*lambda
    v[i,2] = v[i,2]*lambda
    vx = vx + v[i,1]
    vy = vy + v[i,2]
  end
  # Remove drift
  vx = vx / n
  vy = vy / n
  for i in 1:n
    v[i,1] = v[i,1] - vx
    v[i,2] = v[i,2] - vy
  end

  # Updating velocities
  for i in 1:n
    v[i,1] = v[i,1] + 0.5*(f[i,1]+flast[i,1])*dt
    v[i,2] = v[i,2] + 0.5*(f[i,2]+flast[i,2])*dt
  end

end

