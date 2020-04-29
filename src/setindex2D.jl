#
# returns the indexes (i,j) of given the index of the pilled-up columns
#
function setindex2D(ipair,npairs)
  j = ipair%npairs
  if j == 0
    j = 1
  end
  i = round(Int64,(npairs-j)/npairs)+1
  return i, j
end

function setipair2D(n,i,j)
  if j >= i
    ipair = (i-1)*n + j
  else
    ipair = (j-1)*n + i
  end
  ipair = ipair - round(Int64,(i^2+i)/2)
  return ipair
end

