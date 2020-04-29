#
# Function to plot the energy function
#

using Printf
using Plots
using LaTeXStrings

function plotU(input :: MDInput, filename :: String; size=[400,400], xlim=[0.,-1.], ylim=[0.,-1.], n=100)

  ENV["GKSwstype"]="nul"

  if xlim[2] < 0.
    xlim[1] = input.sig/5. 
    xlim[2] = input.cutoff
  end

  x = collect(xlim[1]:(xlim[2]-xlim[1])/n:xlim[2])   
  U = zeros(length(x))

  for i in 1:n
    if input.uf == "uf_QUAD!"
      if x[i] < input.sig
        U[i] = input.eps*(input.sig-x[i])^2
      end
    else
      U[i] = input.eps^4*( input.sig^12 / x[i]^12 - input.sig^6 / x[i]^6 ) 
    end
  end

  if ylim[2] < 0. 
    if input.uf == "uf_QUAD!"
      ymin = minimum(U)
      ymax = maximum(U)
      ylim = [ ymin-0.05*(ymax-ymin), ymin+1.05*(ymax-ymin) ]
    else
      ymin = minimum(U)
      ymax = -2*ymin
      ylim = [ ymin-0.05*(ymax-ymin), ymin+1.05*(ymax-ymin) ]
    end
  end

  plot(size=size,ylabel="U(r)",xlabel="r")
  plot!(x,U,label="",linewidth=2,xlim=xlim,ylim=ylim)

  fontsize=10
  x = 0.60*(xlim[2]-xlim[1]) + xlim[1]
  d = 0.05*(ymax-ymin) ; y = [ 0.90*ylim[2] + d ] 
  if input.uf == "uf_QUAD!"
    uftype = "Quadratic"
    annotate!(x,yd!(y,d),text(uftype,:left,fontsize,:serif,:black))
    note = raw"\sigma = "*"$(input.sig)"
    annotate!(x,yd!(y,d),text(latexstring(note),:left,fontsize,:serif,:black))
  else
    uftype = "Lennard-Jones"
    annotate!(x,yd!(y,d),text(uftype,:left,fontsize,:serif,:black))
    note = raw"\sigma = "*"$(input.sig)"
    annotate!(x,yd!(y,d),text(latexstring(note),:left,fontsize,:serif,:black))
    note = raw"\varepsilon = "*"$(input.eps)"
    annotate!(x,yd!(y,d),text(latexstring(note),:left,fontsize,:serif,:black))
  end

  savefig(filename)

end
