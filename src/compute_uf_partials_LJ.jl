# Function that updates partial force and energy vectors, used for parallel computation

function compute_uf_partials_LJ!(it :: Int64, f :: Forces, 
                                 i :: Int64, j :: Int64,
                                 xj :: Float64, yj :: Float64, r :: Float64,
                                 input :: Input)
  r6 = r^6
  r12 = r6^2
  r7 = r6*r
  r13 = r12*r 

  f.upartial[it] = f.upartial[it] + f.eps4*( f.sig12 / r12 - f.sig6 / r6 ) 
  
  drdxi = -xj/r
  drdyi = -yj/r 

  fx = -f.eps4*( (f.sig1212/r13) - (f.sig66/r7) )*drdxi
  fy = -f.eps4*( (f.sig1212/r13) - (f.sig66/r7) )*drdyi

  f.fpartial[it][i,1] = f.fpartial[it][i,1] + fx
  f.fpartial[it][i,2] = f.fpartial[it][i,2] + fy 
  f.fpartial[it][j,1] = f.fpartial[it][j,1] - fx
  f.fpartial[it][j,2] = f.fpartial[it][j,2] - fy

end

