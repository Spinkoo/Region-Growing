# Region-Growing
Region growing segmentation algorithm using python 



The algorithm combines the distance between the 3 color spaces ( RGB ) to measure the homogeneity of 2 pixels 

( The threshold of a region with a pixel depends on the variance of pixels inside  that region )

The choice of the seeds is  random 



* EXAMPLE TO USE 

Command line :

```python RegionGrowing.py "imagepath" "maximum threshold possible"``` ( since the threshold is depenedant on the variance of pixels in a region )
3 examples with the perfect threshold value :

* Unsupervised segmentation 

```
python RegionGrowing.py examples/cat.jpg 10
```


![Screenshot](examples/cat.jpg)
![Screenshot](outputs/cat.jpg)

```
python RegionGrowing.py examples/mri.jpg 15
```

![Screenshot](examples/mri.jpg)
![Screenshot](outputs/mri.jpg)

```
python RegionGrowing.py examples/apple.jpg 12
```

![Screenshot](examples/apple.jpg)
![Screenshot](outputs/apple.jpg)

* Supervised segmentation 

```
python RegionGrowingSV.py examples/apple.jpg 12
```

The image will popup :

1-left click with the mouse to choose all the seeds

2-right click with the mouse  when you finish choosing the seeds so the algorithm starts
