using BenchmarkTools
using Test

# Distance function, considering PBC
function r(x,y)
  side = 10.
  for i in 1:2
    dx = (y[i]-x[i])%side
    if dx > side/2
      y[i] = y[i] - side
    elseif dx < -side/2
      y[i] = y[i] + side
    end
  end
  return sqrt((y[1]-x[1])^2+(y[2]-x[2])^2)
end

# Potential energy function
U(r,eps,sig) = 4*eps*((sig/r)^12 - (sig/r)^6)

# Compute total potential energy for all pairs
function UT1(x,eps,sig)
  ut = 0.
  for i in 1:length(x)-1, j in i+1:length(x)
    rij = r(x[i],x[j])
    ut += U(rij,eps,sig)
  end
  return ut
end

# Compute total potential energy, but do not compute u if rij > 2.
function UT2(x,eps,sig)
  ut = 0.
  for i in 1:length(x)-1, j in i+1:length(x)
    rij = r(x[i],x[j])
    if rij <= 2.
      ut += U(rij,eps,sig)
    end
  end
  return ut
end

# Generate 100 points
x = [ 10*rand(2) for i in 1:100 ]
# Test if UT1 provides the same result as UT2
eps = 2.0
sig = 0.5
@test UT1(x,eps,sig) ≈ UT2(x,eps,sig)

# Evaluate code speed
print("UT1: "); @btime UT1($x,$eps,$sig)
print("UT2: "); @btime UT2($x,$eps,$sig)
