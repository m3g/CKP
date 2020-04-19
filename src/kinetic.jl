#
# Function that computes the kinetic energy
#

function kinetic(n,v)

  kinetic = 0.
  for i in 1:n
    kinetic = kinetic + 0.5*(v[i,1]^2 + v[i,2]^2)
  end

  return kinetic

end

