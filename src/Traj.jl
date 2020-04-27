#
# Structure to contain the trajectory data
#
struct Traj
  n :: Int64
  nsteps :: Int64
  atoms :: Vector{Atoms}
  potential :: Vector{Float64}
  kinetic :: Vector{Float64}
  total :: Vector{Float64}
  time :: Vector{Float64}
  nenc :: Vector{Float64}
end

# Initialize from number of atoms and number of steps to be saved
function Traj(n :: Int64, nsave :: Int64) 
  nsteps = nsave 
  traj = Traj(
              n, # number of particles
              nsteps, # nsteps
              Vector{Atoms}(undef,nsteps), # atoms 
              zeros(nsteps), # potential 
              zeros(nsteps), # kinetic 
              zeros(nsteps), # total 
              zeros(nsteps), # time 
              zeros(nsteps), # nenc
              )
  for i in 1:nsteps
    traj.atoms[i] = Atoms(n)
  end
  return traj
end

