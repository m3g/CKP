
using Parameters

@with_kw struct Input

  #
  # Atomistic simulation parameters
  #

  # Number of particles
  n :: Int64 = 1000

  # Simulation time
  dt :: Float64 = 0.1
  nprod :: Int64 = 10000

  # Size of the box 
  side :: Float64 = 1000.
  cutoff :: Float64 = 10.

  # Printing properties
  iprint :: Int64 = 100

  # Save how many points of the trajectory:
  nsave :: Int64 = 200

  # Temperature
  kavg_target :: Float64 = 5.
  kavg_tol :: Float64 = 1e-3

  # Parameters of Berendsen bath
  tau :: Float64 = 50. 
  nequil :: Int64 = -1

  # Lennard-Jones parameters
  eps :: Float64 = 1. 
  sig :: Float64 = 2.

  # Parameters of optimization method for initial point
  tol :: Float64 = 1e-2

  # Fraction of initially contamined individuals
  f0 :: Float64 = 0.01

  # Cross-section and probability of contamination
  xsec :: Float64 = 4.
  pcont :: Float64 = 0.3
 
  # chance of dieing or getting immune (per step)
  pdie :: Float64 = 0.0001
  pimmune :: Float64 = 0.0005

  # Energy function (defaults to QUAD inside codes)
  uf = "uf_QUAD!"

end

# Avoid stupid typos when initializing
input = Input


