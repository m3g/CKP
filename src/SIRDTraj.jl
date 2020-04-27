#
# SIRD model trajectory structure
#

struct SIRDTraj
  nsteps :: Int64
  U :: Vector{Float64}
  S :: Vector{Float64}
  D :: Vector{Float64}
  I :: Vector{Float64}
  time :: Vector{Float64}
end

function SIRDTraj( input :: SIRDInput )
  nsteps = round(Int64,input.nsave)
  U = Vector{Float64}(undef,nsteps)
  S = Vector{Float64}(undef,nsteps)
  D = Vector{Float64}(undef,nsteps)
  I = Vector{Float64}(undef,nsteps)
  time = Vector{Float64}(undef,nsteps)
  return SIRDTraj(nsteps,U,S,D,I,time)
end

