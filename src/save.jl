using StructTypes
using JSON3

struct SaveData
  input :: MDInput
  traj :: MDTraj
end

StructTypes.StructType(::Type{MDInput}) = StructTypes.Struct()
StructTypes.StructType(::Type{MDTraj}) = StructTypes.Struct()
StructTypes.StructType(::Type{SaveData}) = StructTypes.Struct()
StructTypes.StructType(::Type{Atoms}) = StructTypes.Struct()

function write(input :: MDInput, traj :: MDTraj, filename :: String)
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
  traj = MDTraj(S.input.n,S.input.nsave)
  # Need to convert the MDTraj structure because the coordinates
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
    traj.U[i] = S.traj.U[i]
    traj.S[i] = S.traj.S[i]
    traj.D[i] = S.traj.D[i]
    traj.I[i] = S.traj.I[i]
  end
  input = S.input
  S = nothing
  return input, traj
end

