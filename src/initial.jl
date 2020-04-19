#
# Create initial point and minimize
#

function initial!(n,x, ff :: ForceField)

  # Creating random initial coordinates

  i = 0
  while i < n
    i = i + 1
    x[i,1] = -ff.side/2.0 + ff.side*rand()
    x[i,2] = -ff.side/2.0 + ff.side*rand()
  end

  xtrial = similar(x)
  f = similar(x)

  # Minimizing the energy of the initial point

  ulast = potential(n,x,ff)
  println("Energy before minimization: ", ulast)

  dx = 1.0
  fnorm = 1.0
  while fnorm > 1.e-5  

    # Compute gradient

    force!(n,x,f,ff)
    fnorm = 0.
    for i in 1:n
      fnorm = fnorm + f[i,1]^2 + f[i,2]^2
    end
    fnorm = fnorm / n

    # Compute trial point ( xtrial = x - (dU/dx)*dx )

    for i in 1:n
      xtrial[i,1] = x[i,1] + f[i,1]*dx
      xtrial[i,2] = x[i,2] + f[i,2]*dx
      xtrial[i,1] = image(xtrial[i,1],ff)
      xtrial[i,2] = image(xtrial[i,2],ff)
    end
    ustep = potential(n,xtrial,ff)

    # If energy decreased, accept, if not, reject and decrease dx

    if ustep < ulast
      for i in 1:n
        x[i,1] = xtrial[i,1]
        x[i,2] = xtrial[i,2]
      end
      ulast = ustep
      dx = dx * 2.
    else
      dx = dx / 2.      
    end
  end

  println("Energy after minimization: ", potential(n,x,ff))   

end






