
p = [ 10*rand(2) for i in 1:100 ]

ijcell(p,cutoff) = [ trunc(Int64,p[1]/cutoff) + 1, trunc(Int64,p[2]/cutoff) + 1 ]

function cells(p,cutoff,side)
  ncells_x = trunc(Int64,side/cutoff) + 1
  ncells_y = trunc(Int64,side/cutoff) + 1
  celllist = zeros()
  for i in 1:length(p)
    

  end
  return celllist
end

