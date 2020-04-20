
using Parameters

@with_kw struct InputData

  # Number of particles

  n :: Int64 = 100

  # Simulation time

  dt :: Float64 = 0.05
  nprod :: Int64 = 1000

  # Size of the box 

  side :: Float64 = 100.

  # Printing properties

  iprint :: Int64 = 100

  # Save how many points of the trajectory:

  nsave :: Int64 = 200

  # Temperature

  kavg_target :: Float64 = 0.6

  # Parameters of Berendsen bath

  tau :: Float64 = 50. 
  nequil :: Int64 = 500

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

end

