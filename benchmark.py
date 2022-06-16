from time import time
from c_RegionGrowing import regionGrow
#or from RegionGrowing import regionGrow to avoid the cythonzied version
#from RegionGrowing import regionGrow 
import sys
import cv2


#Path, threshold.


if len(sys.argv) == 3:
    exemple = regionGrow(sys.argv[1],sys.argv[2])
else:
    #take demo parameter values for the path and the threshold
    exemple = regionGrow('apple.jpg', 12)

#benchmark execution time
start = time()
exemple.ApplyRegionGrow()
print(time()-start)




#imshow the results
cv2.imshow('Output', exemple.SEGS)
cv2.waitKey(0)