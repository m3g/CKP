
using Parameters

@with_kw struct ForceField

  # Size of the box 

  side :: Float64 = 100.

  # Interactions

  eps :: Float64 = 1. 
  sig :: Float64 = 2.

end

