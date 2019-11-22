# Region-Growing
Region growing segmentation algorithm using python 



The algorithm combines the distance between the 3 color spaces ( RGB ) to measure the homogeneity of 2 pixels 

( The threshold of a region with a pixel depends on the variance of pixels inside  that region )

The choice of the seeds is  random 



* EXAMPLE TO USE *

Command line :
python RegionGrowing.py "imagepath" "maximum threshold possible" ( since the threshold is depenedant on the variance of pixels in a region )
3 examples with the perfect threshold value :

* for the unsupervised segmentation *

python RegionGrowing.py 2.jpg 10

python RegionGrowing.py mri.jpg 15

python RegionGrowing.py apple.jpg 12


* for the supervised segmentation *

python RegionGrowingSV.py apple.jpg 12

The image will popup :

1-left click with the mouse to choose all the seeds

2-right click with the mouse  when you finish choosing the seeds so the algorithm starts
