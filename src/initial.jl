#
# Create initial point and minimize
#

function initial(input :: InputData)

  # To clear out the code
  n = input.n

  # Structures to save data
  atoms = Atoms(n)
  traj = Traj(n,input.nsave)

  # Local names for code simplicity
  x = atoms.x # this does not not copy x, so that is fine

  # Creating random initial coordinates

  i = 0
  while i < n
    i = i + 1
    x[i,1] = -input.side/2.0 + input.side*rand()
    x[i,2] = -input.side/2.0 + input.side*rand()
  end

  xtrial = similar(x)
  f = similar(x)

  # Minimizing the energy of the initial point

  ulast = potential(n,x,input)
  println("Energy before minimization: ", ulast)

  dx = 1.0
  fnorm = 1.0
  while fnorm > input.tol

    # Compute gradient

    force!(n,x,f,input)
    fnorm = 0.
    for i in 1:n
      fnorm = fnorm + f[i,1]^2 + f[i,2]^2
    end
    fnorm = fnorm / n

    # Compute trial point ( xtrial = x - (dU/dx)*dx )

    for i in 1:n
      xtrial[i,1] = x[i,1] + f[i,1]*dx
      xtrial[i,2] = x[i,2] + f[i,2]*dx
      xtrial[i,1] = image(xtrial[i,1],input)
      xtrial[i,2] = image(xtrial[i,2],input)
    end
    ustep = potential(n,xtrial,input)

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

  println("Energy after minimization: ", potential(n,x,input))   

  return atoms, traj

end






