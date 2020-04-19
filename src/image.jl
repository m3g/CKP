#
# Move coordinates to minimum perioddic images
#

function image(x,ff :: ForceField)
  image = x%ff.side
  if image <= -ff.side/2.0
    image = image + ff.side
  elseif image > ff.side/2.0
    image = image - ff.side
  end
  return image
end
