#
# Structure to contain force vector and partial vector for
# parallel computations
#

struct Forces

  f :: Array{Float64}
  fpartial :: Array{Array{Float64}}
  upartial :: Vector{Float64}
  nenc_partial :: Vector{Int64}

end

# Initializer

Forces(n::Int64) = 
  Forces(zeros(n,2), # actual forces
         [ zeros(n,2) for i in 1:Threads.nthreads() ], # partials for parallel computations
         zeros(Float64,Threads.nthreads()), # partial energies for parallel computation
         zeros(Int64,Threads.nthreads()) ) # partial number of encounters


