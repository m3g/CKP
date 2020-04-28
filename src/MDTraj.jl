#
# Structure to contain the trajectory data
#
struct MDTraj

  n :: Int64
  nsteps :: Int64
  atoms :: Vector{Atoms}
  potential :: Vector{Float64}
  kinetic :: Vector{Float64}
  total :: Vector{Float64}
  time :: Vector{Float64}
  nenc :: Vector{Float64} # Number of encounters

  # Results along the trajectory
  U :: Vector{Float64} # Susceptible
  S :: Vector{Float64} # Sick
  D :: Vector{Float64} # Dead
  I :: Vector{Float64} # Immune

end

# Initialize from number of atoms and number of steps to be saved
function MDTraj(n :: Int64, nsave :: Int64) 
  nsteps = nsave 
  traj = MDTraj(
                n, # number of particles
                nsteps, # nsteps
                Vector{Atoms}(undef,nsteps), # atoms 
                zeros(nsteps), # potential 
                zeros(nsteps), # kinetic 
                zeros(nsteps), # total 
                zeros(nsteps), # time 
                zeros(nsteps), # nenc
                zeros(nsteps), # U
                zeros(nsteps), # S
                zeros(nsteps), # D
                zeros(nsteps), # I
                )
  for i in 1:nsteps
    traj.atoms[i] = Atoms(n)
  end
  return traj
end

