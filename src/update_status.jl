#
# Update status of pacients
#

function update_status( s1 :: Int64, s2 :: Int64, d :: Float64, input :: InputData)
   # Check contatmination
   if  ( s1 == 1 || s2 == 1 ) && ( s1 < 3 && s2 < 3 ) # 3 nor 4 are dead and immune
     # if the distance is smaller than the x-section
     if d < input.xsec  
       if rand() < input.pcont
         return 1, 1
       end
     end
   end
   return s1, s2
end
