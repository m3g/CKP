#
# Subroutine that writes the current coordinates to output file
#

function printx(stream,n,x,time,ff)
  println(stream,n)
  println(stream,"md program, time = ", time)
  for i in 1:n
    xt = image(x[i,1],ff)
    yt = image(x[i,2],ff)
    println(stream,"H ",xt," ",yt," ",0.)
  end
end
