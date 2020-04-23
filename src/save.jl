using StructTypes
using JSON3

struct SaveData
  input :: Input
  traj :: Traj
end

StructTypes.StructType(::Type{Input}) = StructTypes.Struct()
StructTypes.StructType(::Type{Traj}) = StructTypes.Struct()
StructTypes.StructType(::Type{SaveData}) = StructTypes.Struct()
StructTypes.StructType(::Type{Atoms}) = StructTypes.Struct()

function write(input :: Input, traj :: Traj, filename :: String)
  S = SaveData(input,traj)
  f = open(filename,"w")
  JSON3.write(f,S)
  close(f)
end

function read(filename :: String)
  input, traj = read_wg(filename)
  GC.gc()
  return input, traj
end

function read_wg(filename :: String)
  f = open(filename,"r")
  S = JSON3.read(f,SaveData)
  traj = Traj(S.input.n,S.input.nsave)
  # Need to convert the Traj structure because the coordinates
  # are read in a single column, instead of the [n,2] array we want.
  for i in 1:S.input.nsave 
    for iat in 1:S.input.n
      traj.atoms[i].x[iat,1] = S.traj.atoms[i].x[iat]
      traj.atoms[i].x[iat,2] = S.traj.atoms[i].x[iat+S.input.n]
      traj.atoms[i].status[iat] = S.traj.atoms[i].status[iat]
    end
    traj.potential[i] = S.traj.potential[i]
    traj.kinetic[i] = S.traj.kinetic[i]
    traj.total[i] = S.traj.total[i]
    traj.time[i] = S.traj.time[i]
    traj.nenc[i] = S.traj.nenc[i]
  end
  input = S.input
  S = nothing
  return input, traj
end

