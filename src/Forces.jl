#
# Structure to contain force vector and partial vector for
# parallel computations
#

struct Forces

  # Force array
  f :: Array{Float64}

  # Partial vectors for parallel computation
  fpartial :: Array{Array{Float64}}
  upartial :: Vector{Float64}
  nenc_partial :: Vector{Int64}

  # Constants that have to be computed every time
  sig2 :: Float64
  cutoff2 :: Float64
  sig6 :: Float64
  sig12 :: Float64
  sig66 :: Float64
  sig1212 :: Float64
  eps4 :: Float64

  # Parameters and arrays for linked lists
  nboxes :: Int64
  boxside :: Float64
  ifirst :: Array{Int64}
  inext :: Vector{Int64}

  # Array to check for previous and new encounters
  encij :: Vector{Bool}

end

# Initializer

function Forces(input :: MDInput)  

  boxside = input.side/input.cutoff
  nboxes = round(Int64,input.side/boxside)
  ifirst = Array{Int64}(undef,nboxes,nboxes)
  inext = Vector{Int64}(undef,input.n)

  return Forces(zeros(input.n,2), # actual forces
                [ zeros(input.n,2) for i in 1:Threads.nthreads() ], # partials for parallel computations
                zeros(Float64,Threads.nthreads()), # partial energies for parallel computation
                zeros(Int64,Threads.nthreads()), # partial number of encounters
                input.sig^2, input.cutoff^2, input.sig^6, input.sig^12, -6*input.sig^6, -12*input.sig^12, 4*input.eps,
                nboxes, boxside, ifirst, inext,
                zeros(round(Int64,(input.n*(input.n-1))/2)) )

end


