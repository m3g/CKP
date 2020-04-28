#
# Function that computes the forces and potential energy,
# using a simple quadratic energy function
#
# modifies vector f, returns u

function uf_QUAD_LL!(n :: Int64, x :: Array{Float64}, f :: Array{Float64}, input :: MDInput)

  # Clear forces, ifirst, and inext arrays
  resetForces(f)
  @. f.ifirst = 0
  @. f.inext = 0

  # Add atoms to their boxes
  for i in 1:n
    ibox = trunc(Int64,x[i,1]/input.cutoff)+1
    jbox = trunc(Int64,x[i,2]/input.cutoff)+1
    inext[i] = ifirst[ibox,jbox]
    ifirst[ibox,jbox] = i
  end

voltar

  # Cycle over boxes computing interactions
  for iboxes in 1:nboxes 

    ibox, jbox = setindex2D(iboxex,nboxes)
    i = ifirst[ibox,jbox]
    while i > 0 

      # inside box
      celluf!(i,u,f,x,input,ibox,jbox)

      i = inext[i]
    end

  end

end

# Computes the interaction of atom i with atoms of box ibox, jbox

function celluf!(i,u,f,x,input,ibox,jbox,ifirst,inext)
 
  upair = 0.
  if ibox == jbox
    j = inext[i]
  else
    j = ifirst[ibox,jbox]
  end
  while j > 0
    
    xj = x[j,1] - x[i,1]
    yj = x[j,2] - x[i,2]
    xj = image(xj,input)
    yj = image(yj,input)

    r2 = xj^2 + yj^2
    if r2 > input.cutoff^2
      continue
    end
    r = sqrt(r2)
    
    if r < input.sig
      upartial[Threads.threadid()] = upartial[Threads.threadid()] + input.eps*(input.sig-r)^2
      drdxi = -xj/r
      drdyi = -yj/r 
      fx = 2*input.eps*(input.sig-r)*drdxi
      fy = 2*input.eps*(input.sig-r)*drdyi
      f[i,1] = f[i,1] + fx
      f[i,2] = f[i,2] + fy 
      f[j,1] = f[j,1] - fx
      f[j,2] = f[j,2] - fy
      j = inext[j]
    end
   
  end

end








  for ipair in 1:npairs 

    j = (npairs%n)+1
    i = (npairs-j)/n+1
     

  Threads.@threads for i in 1:n-1

    for j in i+1:n

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,input)
      yj = image(yj,input)

      r2 = xj^2 + yj^2
      if r2 > input.cutoff^2
        continue
      end
      r = sqrt(r2)
      
      if r < input.sig

        upartial[Threads.threadid()] = upartial[Threads.threadid()] + input.eps*(input.sig-r)^2
      
        drdxi = -xj/r
        drdyi = -yj/r 

        fx = 2*input.eps*(input.sig-r)*drdxi
        fy = 2*input.eps*(input.sig-r)*drdyi

        f[i,1] = f[i,1] + fx
        f[i,2] = f[i,2] + fy 
        f[j,1] = f[j,1] - fx
        f[j,2] = f[j,2] - fy

      end

    end

  end

  return sum(upartial)

end

function uf_QUAD!(n :: Int64, atoms :: Atoms, f :: Array{Float64}, input :: MDInput)

  x = atoms.x

  @. f = 0.
  upartial = zeros(Float64,Threads.nthreads())
  nenc_partial = zeros(Int64,Threads.nthreads()) 

  Threads.@threads for i in 1:n-1

    if atoms.status[i] == 2 
      continue
    end

    for j in i+1:n

      if atoms.status[j] == 2 
        continue
      end

      xj = x[j,1] - x[i,1]
      yj = x[j,2] - x[i,2]
      xj = image(xj,input)
      yj = image(yj,input)

      r2 = xj^2 + yj^2
      if r2 > input.cutoff^2
        continue  
      end
      r = sqrt(r2)

      if r < input.sig

        upartial[Threads.threadid()] = upartial[Threads.threadid()] + input.eps*(input.sig-r)^2
      
        drdxi = -xj/r
        drdyi = -yj/r 

        fx = 2*input.eps*(input.sig-r)*drdxi
        fy = 2*input.eps*(input.sig-r)*drdyi

        f[i,1] = f[i,1] + fx
        f[i,2] = f[i,2] + fy 
        f[j,1] = f[j,1] - fx
        f[j,2] = f[j,2] - fy

      end

      atoms.status[i], atoms.status[j], encounter = update_status(atoms.status[i],atoms.status[j],r,input)
      if encounter
        nenc_partial[Threads.threadid()] = nenc_partial[Threads.threadid()] + 1
      end

    end

  end

  return sum(upartial), sum(nenc_partial)

end

