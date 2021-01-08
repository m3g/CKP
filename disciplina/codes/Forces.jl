module Forces

  initial_point(side,N) = 
     [ [-side/2 + rand()*side, -side/2+rand()*side] for i in 1:N ]

  # Energies
  upair(x,y) = (x[1]-y[1])^2 + (x[2]-y[2])^2 
  function utotal(p)
    u = 0.
    for i in 1:length(p)-1
      for j in i+1:length(p)
        u += upair(p[i],p[j])
      end
    end
    u
  end

  # Forces
  function forcepair(x,y) 
    dx = x[1]-y[1]
    dy = x[2]-y[2]

    upair = dx^2 + dy^2

    dudx1 = -2*dx
    dudx2 = -2*dy
    return upair, (dudx1, dudx2)
  end

  # Compute all forces, modifies vector f
  function forces!(p,f)
    u = 0.
    for i in 1:length(f)
      f[i] .= 0
    end
    for i in 1:length(p)-1
      for j in i+1:length(p)
        up, fp = forcepair(p[i],p[j])
        u += up
        f[i] .= f[i] .+ fp
        f[j] .= f[j] .- fp
      end
    end
    return u, f
  end

  export upair, utotal, forcepair, forces!, initial_point
end



