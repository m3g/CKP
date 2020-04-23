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

