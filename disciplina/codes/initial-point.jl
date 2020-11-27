#
# Generate an initial point in a grid, with a minimum distance defined
#

# To plot:
# using Plots
# scatter([ p[i][1] for i in 1:N ],[ p[i][2] for i in 1:N ],markersize=0.5,label="")

import Random

# Function that introduces a perturbation in the grid point
perturbation(step,σ) = -σ + 2*σ*rand()

"""

```
initial_point(N,side,tol;seed=123)
```

Generates a grid of N particles in a square of side `side`, with
perturbed coordinates but which satisfy a minimum distance greater
than `tol` 

`N`: number of particles.

`side`: side of the square

`tol`: minimum distance allowed between particles

The optional keyword parameter `seed`, if set to `-1`, produces a
random seed at each run.

## Example

Generate 10_000 points in a grid of side 100, with a guaranteed minimum
distance greater than 0.5:

```
p = initial_point(10_000,100,0.5)
```

Use a random seed:

```
p = initial_point(10_000,100,0.5,seed=-1)
```

"""
function initial_point(N,side,tol;seed=123)

  # Use a different seed if desired
  if seed > 0
    Random.seed!(seed)
  else
    Random.seed!()
  end
  p = [ zeros(2) for i in 1:N ]

  # Properties of the regular grid
  l = ceil(Int,sqrt(N))
  step = (side-tol)/l
  if tol > step
    error("tol must be smaller than (side-tol)/√N = $step")
  end

  # The grid has l^2 points, but this is generally greater
  # than N. Thus, we generate list of points to be skiped 
  skip = Int[]
  while length(skip) < l^2 - N
    i = rand(1:l^2)
    if findfirst(isequal(i), skip) == nothing
      push!(skip,i)
    end
  end

  # Maximum perturbation
  σ = (step-tol)/2

  # Generate points
  ip = 0
  igrid = 0 
  x = [ tol/2, tol/2 ]
  for i in 1:l 
    for j in 1:l
      igrid += 1
      if findfirst(isequal(igrid),skip) != nothing
        continue
      end
      # update x, with a perturbation of ±0.1*step
      ip += 1
      p[ip] .= x .+ perturbation(step,σ)
      x[2] = x[2] + step 
    end
    x[2] = tol/2
    x[1] = x[1] + step
  end

  return p
end

