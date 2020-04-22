# Function that reset the forces and partial vectors used for parallel computation

function resetForces!(f :: Forces)
  nt = Threads.nthreads()
  @. f.f = 0.
  for i in 1:nt
    @. f.fpartial[i] = 0.
  end
  @. upartial = 0.
  @. nenc_partial = 0.
end
