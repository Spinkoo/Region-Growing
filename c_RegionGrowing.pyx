import cv2
import numpy as np
import random
import sys
import cython



#class pour une pile
class Stack():
    def __init__(self):
        self.item = []
        self.obj=[]
    def push(self, value):
        self.item.append(value)

    def pop(self):
        return self.item.pop()

    def size(self):
        return len(self.item)

    def isEmpty(self):
        return self.size() == 0

    def clear(self):
        self.item = []

cdef class regionGrow():
  
    cdef public int[:, :, :]  im
    cdef public int h, w, currentRegion, iterations, prev_region_count
    cdef public double thresh
    cdef public object stack, passedBy,  SEGS
    cdef double[20] var


    def __init__(self,im_path,threshold):
        self.im = np.array(cv2.imread(im_path,1)).astype('int')
        #self.readImage(im_path)
        self.h, self.w,_ = np.array(cv2.imread(im_path,1)).shape
        self.passedBy = np.zeros((self.h,self.w), np.double)
        self.currentRegion = 0
        self.iterations=0
        self.SEGS=np.zeros((self.h,self.w,3), dtype='uint8')
        self.stack = Stack()
        self.thresh=float(threshold)
        
        self.prev_region_count=0
        self.var = np.zeros(20, dtype=np.float16)
        
    def readImage(self, img_path):
        self.im = cv2.imread(img_path,1)
    

    cdef getNeighbour(self, int x0, int y0):
        neighbour = []
        for i in (-1,0,1):
            for j in (-1,0,1):
                if (i,j) == (0,0): 
                    continue
                x = x0+i
                y = y0+j
                if self.limit(x,y):
                    neighbour.append((x,y))
        return neighbour

    cpdef ApplyRegionGrow(self):
        randomseeds=[[self.h/2,self.w/2],
            [self.h/3,self.w/3],[2*self.h/3,self.w/3],[self.h/3-10,self.w/3],
            [self.h/3,2*self.w/3],[2*self.h/3,2*self.w/3],[self.h/3-10,2*self.w/3],
            [self.h/3,self.w-10],[2*self.h/3,self.w-10],[self.h/3-10,self.w-10]
                    ]
        np.random.shuffle(randomseeds)
        cdef int x, y, x0, y0
        for x0 in range (self.h):
            for y0 in range (self.w):
         
                if self.passedBy[x0,y0] == 0 and (int(self.im[x0,y0,0])*int(self.im[x0,y0,1])*int(self.im[x0,y0,2]) > 0) :  
                    self.currentRegion += 1
                    self.passedBy[x0,y0] = self.currentRegion
                    self.stack.push((x0,y0))
                    self.prev_region_count=0
                    while not self.stack.isEmpty():
                        x,y = self.stack.pop()
                        self.BFS(x,y)
                        self.iterations+=1
                    if(self.PassedAll()):
                        break
                    if(self.prev_region_count<8*8):  

                        self.passedBy[self.passedBy==self.currentRegion] = 0
                        x0=random.randint(x0-4,x0+4)
                        y0=random.randint(y0-4,y0+4)
                        x0=max(0,x0)
                        y0=max(0,y0)
                        x0=min(x0,self.h-1)
                        y0=min(y0,self.w-1)
                        self.currentRegion-=1

        self.SEGS[self.passedBy == 0] = 255,255,255

        msks = self.passedBy != 0
        expanded_passby = np.expand_dims(self.passedBy[msks], axis=1)

        op = np.concatenate((expanded_passby * 35 % 255,expanded_passby * 90 % 255 ,expanded_passby * 30 % 255), axis=-1)
        
        self.SEGS[msks] = op

        if(self.iterations>200000):
            print("Max Iterations")
        return self.SEGS
    cdef BFS(self, int x0,int y0):
        cdef int regionNum, x, y
        
        regionNum = self.passedBy[x0,y0]
        
        if self.var[regionNum] == 0:
            self.var[regionNum] = self.thresh
        neighbours=self.getNeighbour(x0,y0)
        elems =  []
        elems.append(sum(self.im[x0, y0, :]) / 3 )
        

        for x,y in neighbours:
            if self.passedBy[x,y] == 0 and self.distance(x,y,x0,y0) < self.var[regionNum]:
                if(self.PassedAll()):
                    break
                self.passedBy[x,y] = regionNum

                self.stack.push((x,y))

                elems.append( (self.im[x,y,0] + self.im[x,y,1] + self.im[x,y,2])  / 3)

                self.var[regionNum] = np.var(elems)
                self.prev_region_count+=1
            
            self.var[regionNum] = max(self.var[regionNum], self.thresh)

    cdef BFS_elem_prop(self, int x0,int y0, int x, int y, int regionNum, ):

        elems =  []
        elems.append(sum(self.im[x0, y0, :]) / 3 )


                
    
    
    def PassedAll(self):
   
        return self.iterations>200000 or np.count_nonzero(self.passedBy > 0) == self.w*self.h


    cdef limit(self, int x,int y):
        return  0<=x<self.h and 0<=y<self.w
    def distance(self, int x,int y,int x0,int y0):
        #return np.linalg.norm(self.im[x,y]-self.im[x0,y0], ord=2)
        #a = self.im[x,y].astype('int')
        #b = self.im[x0,y0].astype('int')
        #return np.linalg.norm(a-b, ord=2)
        return ((self.im[x,y,0]-self.im[x0,y0,0])**2+(self.im[x,y,1]-self.im[x0,y0,1])**2+(self.im[x,y,2]-self.im[x0,y0,2])**2)**0.5




if __name__ == '__main__':
    exemple = regionGrow(sys.argv[1],sys.argv[2])
    exemple.ApplyRegionGrow()


