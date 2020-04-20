
using Parameters

@with_kw struct InputData

  # Number of particles

  n :: Int64 = 100

  # Simulation time

  dt :: Float64 = 0.05
  nprod :: Int64 = 50000

  # Size of the box 

  side :: Float64 = 100.

  # Printing properties

  iprint :: Int64 = 1
  iprintxyz :: Int64 = 10
  printequil :: Bool = false
  printvel :: Bool = false

  # Save how many points of the trajectory:

  nsave :: Int64 = 200

  # Temperature

  kavg_target :: Float64 = 0.6

  # Parameters of Berendsen bath

  tau :: Float64 = 50. 
  nequil :: Float64 = 1000
  kavg_target :: Float64 = 0.6

  # Lennard-Jones parameters

  eps :: Float64 = 1. 
  sig :: Float64 = 2.

  # Parameters of optimization method for initial point

  tol :: Float64 = 1e-5

end

