# Function that reset the forces and partial vectors used for parallel computation

function resetForces!(f :: Forces)
  @. f.f = 0.
  for i in 1:Threads.nthreads()
    @. f.fpartial[i] = 0.
  end
  @. f.upartial = 0.
  @. f.nenc_partial = 0.
end
