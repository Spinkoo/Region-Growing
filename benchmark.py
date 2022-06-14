from time import time
from c_RegionGrowing import regionGrow
#or from RegionGrowing import regionGrow to avoid the cythonzied version
import sys


#Path, threshold.


if len(sys.argv) == 3:
    exemple = regionGrow(sys.argv[1],sys.argv[2])
else:
    #take demo parameter values for the path and the threshold
    exemple = regionGrow('apple.jpg', 12)

#time the exeuction of the algorithm
start = time()
exemple.ApplyRegionGrow()
print("Time : "+str(time()-start))