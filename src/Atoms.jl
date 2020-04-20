
struct Atoms
  x :: Array{Float64}
  status :: Vector{Int64}
end
Atoms(n :: Int64) = Atoms(zeros(n,2),zeros(Int64,n))

