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
  traj = Traj(
              n, # number of particles
              nsave, # nsteps
              Vector{Atoms}(undef,nsave), # atoms 
              zeros(nsave), # potential 
              zeros(nsave), # kinetic 
              zeros(nsave), # total 
              zeros(nsave), # time 
              zeros(nsave), # nenc
              )
  for i in 1:nsave
    traj.atoms[i] = Atoms(n)
  end
  return traj
end

