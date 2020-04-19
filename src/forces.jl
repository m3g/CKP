#
# Subroutine that computes the force
#
# modifies vector f

function force!(n,x,f,ff)

  for i in 1:n
    f[i,1] = 0.
    f[i,2] = 0.
  end

  for i in 1:n-1
    for j in i+1:n

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,ff)
      yj = image(yj,ff)

      r = sqrt(xj^2 + yj^2)
      
      drdxi = -xj/r
      drdyi = -yj/r 

      fx = -4.0*ff.eps*( (-12.0*ff.sig^12/r^13) - (-6.0*ff.sig^6/r^7) )*drdxi
      fy = -4.0*ff.eps*( (-12.0*ff.sig^12/r^13) - (-6.0*ff.sig^6/r^7) )*drdyi

      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy

    end
  end

end
