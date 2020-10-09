using BenchmarkTools
using StaticArrays
using Test
using LoopVectorization

function pot(x,y,eps4,sig6,sig12)
  r2 = (x[1]-y[1])^2 + (x[2]-y[2])^2
  r6 = r2^3
  r12 = r6^2
  return eps4*(sig12/r12 - sig6/r6)
end

function total_pot(p,eps,sig)
  eps4 = 4*eps
  sig6 = sig^6
  sig12 = sig6^2
  total_pot = 0.
  for i in 1:length(p)-1
    @avx for j in i+1:length(p)
      total_pot = total_pot + pot(p[i],p[j],eps4,sig6,sig12)
    end
  end
  return total_pot
end

eps = 4.
sig = 1.
p = [ 10*rand(2) for i in 1:10 ]
r1 = @btime total_pot(p,eps,sig)

p = [ SVector(p[i]...) for i in 1:10 ]
r2 = @btime total_pot(p,eps,sig)

@test r1 ≈ r2

