# Function that updates partial force and energy vectors, used for parallel computation

function compute_uf_partials_QUAD!(it :: Int64, f :: Forces, 
                                   i :: Int64, j :: Int64,
                                   xj :: Float64, yj :: Float64, r :: Float64,
                                   input :: MDInput)

   f.upartial[it] = f.upartial[it] + input.eps*(input.sig-r)^2
   
   drdxi = -xj/r
   drdyi = -yj/r 

   fx = 2*input.eps*(input.sig-r)*drdxi
   fy = 2*input.eps*(input.sig-r)*drdyi

   f.fpartial[it][i,1] = f.fpartial[it][i,1] + fx
   f.fpartial[it][i,2] = f.fpartial[it][i,2] + fy 
   f.fpartial[it][j,1] = f.fpartial[it][j,1] - fx
   f.fpartial[it][j,2] = f.fpartial[it][j,2] - fy

end
