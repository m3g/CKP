
using Parameters

@with_kw struct InputData

  # Number of particles
  n :: Int64 = 100

  # Simulation time
  dt :: Float64 = 0.05
  nprod :: Int64 = 1000

  # Size of the box 
  side :: Float64 = 100.
  cutoff :: Float64 = 10.

  # Printing properties
  iprint :: Int64 = 100

  # Save how many points of the trajectory:
  nsave :: Int64 = 200

  # Temperature
  kavg_target :: Float64 = 0.6
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
  f0 = 0.01

  # Cross-section and probability of contamination
  xsec = 4.
  pcont = 0.3
 
  # chance of dieing or getting immune (per step)
  pdie = 0.0001
  pimmune = 0.01

  # Energy function
  #uf! = uf_LJ!
  uf! = uf_QUAD!

end

