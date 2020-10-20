using Test
using BenchmarkTools

import Random
Random.seed!(321)

# Include function that computes the maximum distance
include("./mindist.jl")

# Function that computes the minimum distance, with a naive algorithm
function mindist_naive(p,cutoff)
  np = length(p)
  d = +Inf
  for ip in 1:np-1
    for jp in ip+1:np
      d = min(d,sqrt( (p[ip][1]-p[jp][1])^2 +
                      (p[ip][2]-p[jp][2])^2) ) 
    end
  end
  return d
end

# Compute the cell to which each particle belongs 
function celllist(p,side,cutoff)
  n = round(Int64,side/cutoff)
  cellparticles = [ Int64[] for i in 1:n, j in 1:n ]
  for i in 1:length(p)
    icell = trunc(Int64,p[i][1]/cutoff) + 1
    jcell = trunc(Int64,p[i][2]/cutoff) + 1
    push!(cellparticles[icell,jcell],i)
  end
  return cellparticles
end

# Positions of 10,000 particles, with side 100. and cutoff 10.
side = 1000.
cutoff = 10.
p = [ side*rand(2) for i in 1:10_000 ]

# Compute the cell of each particle
cellparticles = celllist(p,side,cutoff)
println(" Time for particle classification: ")
@btime celllist($p,$side,$cutoff)

println(" Using mindist: ")
@btime mindist($p,$cellparticles,$cutoff)

println(" Using mindist_naive: ")
@btime mindist_naive($p,$cutoff)

# Check result
dmin_naive = mindist_naive(p,cutoff)
dmin = mindist(p,cellparticles,cutoff)
@test dmin ≈ dmin_naive
