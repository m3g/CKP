#
# Move coordinates to minimum perioddic images
#

function image(x :: Float64, input :: MDInput)
  image = x%input.side
  if image <= -input.side/2.0
    image = image + input.side
  elseif image > input.side/2.0
    image = image - input.side
  end
  return image
end
