# Function that reduces the forces vector and energy after parallel computation

function reduceForces!(f :: Forces)
  u = 0.
  for i in 1:Threads.nthreads()
    u = u + f.upartial[i]
    @. f.f = f.f + f.fpartial[i]
  end
  return u
end

