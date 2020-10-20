#
# Computes the minimum distance between a pair of 
# particles using the linked cell method
#
function mindist(p,cellparticles,cutoff)
  np = length(p) # Number of particles
  nc = size(cellparticles,1) # Dimension of the grid 
  d = +Inf
  for ip in 1:np  
    icell = trunc(Int64,p[ip][1]/cutoff)+1
    jcell = trunc(Int64,p[ip][2]/cutoff)+1
    for i in icell-1:icell+1
      if ( i < 1 || i > nc ) continue end # Border
      for j in jcell-1:jcell+1
        if ( j < 1 || j > nc ) continue end # Borders
        # Loop over the particles of this cell
        for jp in cellparticles[i,j]
          if ( jp <= ip ) continue end # Skip repeated
          # Compute distance and keep minimum
          d = min(d,sqrt( (p[ip][1]-p[jp][1])^2 +
                          (p[ip][2]-p[jp][2])^2) )
        end
      end
    end
  end
  return d
end
