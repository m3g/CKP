#
# Function that computes the fit (least square sense) of a SIRD simulation to the 
# trajectory data
#


sird_data = SIRDTraj(n)


function fiteval(traj :: Traj, sirdinput :: SIRDInput, sird_data :: SIRDInput)

  # For code clarity
  n = traj.nsteps

  # perform SIRD simulation
  sird_traj = sird(sirdinput)

  # sample the SIRD simulation points at the same times that are 
  # available for the data in traj
  jt = 1
  for i in 1:n
    t = traj.time[i]
    jt = findfirst( x -> x > t, sird_data.time[jt:sird_traj.nsteps]) 
    if jt == 1
      sird_data.U[i] = sird_traj
    elseif

  
  end
  
  

  



end


function sample_interpolation(x,y,xmin,xmax,step)

  nx = length(x)
  n = round(Int64,(xmax-xmin)/step+1)
  xnew = Vector{Float64}(undef,n)
  ynew = Vector{Float64}(undef,n)

  for i in 1:n
   xnew[i] = xmin + (i-1)*step 
   ix = findfirst( x -> x > xnew[i], x )
   if ix == 1 
     ynew[i] = y[1]
   elseif ix == nothing
     ynew[i] = y[nx]
   else
     ynew[i] = y[ix-1] + (xnew[i]-x[ix-1])*((y[ix]-y[ix-1])/(x[ix]-x[ix-1]))
   end
  end

  return xnew, ynew

end
