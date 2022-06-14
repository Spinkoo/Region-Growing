from time import time
from c_RegionGrowing import regionGrow
import sys

exemple = regionGrow('apple.jpg', 12)
start = time()
exemple.ApplyRegionGrow()
print("Time : "+str(time()-start))