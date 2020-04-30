#
# SIRD model input data
#

@with_kw struct SIRDInput

  # 
  # SIRD simulation parameters
  #

  Si :: Float64 = 0.01 # Initial fraction of sick individuals
  Di :: Float64 = 0. # Initial fraction of dead indidivuals
  Ii :: Float64 = 0. # Initial fraction of immune individuals

  kc :: Float64  = 0.02 # Rate constant for contamination
  kd :: Float64 = 0.001 # Rate constant for deceases 
  ki :: Float64 = 0.005 # Rate constant for immunization
  kiu :: Float64 = 0.00001 # Rate constant for immunity loss
 
  dt :: Float64 = 0.01 # time step
  tmax :: Float64 = 1000. # maximum time

  tol :: Float64 = 1.e-4 # stop if the fraction of sick people is smaller than this
  
  err :: Float64 = 1.e-3 # error tolerance for integrator

  nsave :: Int64 = 200 # Number of data points be saved
 
  print :: Bool  = true # Print or not data on the screen

end

