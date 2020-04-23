using StructTypes
using JSON3

struct SaveData
  input :: InputData
  traj :: Traj
end

StructTypes.StructType(::Type{InputData}) = StructTypes.Struct()
StructTypes.StructType(::Type{Traj}) = StructTypes.Struct()
StructTypes.StructType(::Type{SaveData}) = StructTypes.Struct()
StructTypes.StructType(::Type{Atoms}) = StructTypes.Struct()

function save_sim(input :: InputData, traj :: Traj, filename :: String)
  S = SaveData(input,traj)
  f = open(filename,"w")
  JSON3.write(f,S)
  close(f)
end

function read_sim(filename :: String)
  f = open(filename,"r")
  S = JSON3.read(f,SaveData)
  traj = Traj(S.input.n,S.input.nsave)
  for i in 1:S.input.nsave 
    for iat in 1:S.input.n
      traj.atoms[i].x[iat,1] = S.traj.atoms[i].x[iat]
      traj.atoms[i].x[iat,2] = S.traj.atoms[i].x[iat+S.input.n]
      traj.atoms[i].status[iat] = S.traj.atoms[i].status[iat]
    end
  end
  return S.input, traj
end


