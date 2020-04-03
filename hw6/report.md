# 数图小作业六

2017011552 陈昭熹

## 队服换色
实现了GUI小程序Suitmorpher，可以通过Matlab Install App途径直接安装，安装时选择.mlappinstall文件即可。

### 彩色分割

彩色分割部分的原理基于课程上老师讲到的`color_slicing.m`，封装在`suite_morpher.m`函数中。通过预先指定的选色矩形区域来采集队服的色度和饱和度均值，并利用此求取全图的H和S参数的方差，利用阈值与方差比较生成二值化mask来标志队服区域。

### HSV空间调色

利用生成的队服区域mask，将区域内图像重新上色，色彩空间选取HSV空间，保持原图的V值不变，将H和S置为用户输入的值，并且重新上色，生成出结果图。

### 结果

我选取了鲜红、粉色、鲜绿、薄荷绿和淡黄五种颜色作为结果图目标颜色，并生成了**5x8=40张图片存放在data包**中。**值得注意的是，五种颜色的定义均是V=100（即亮度最大）时的观感定义，放到每张图片中由于原图区域中亮度不一定是最亮，会导致观感差异。例如粉色可能会变成暗紫色**。五种颜色HSV值如下表所示，实现中V值取原图的值不变，不将其改为100，H取值范围[0,360],S取值范围[0,100]:
| 颜色 | Hue | Saturation |  Value  |
|:---:| :------: | :-----------: | :---: |
|鲜红|   0   |     100     | 100  |
|粉色 |   319    |    44     | 100  |
|鲜绿 |   108    |    100     | 100 |
|薄荷绿 |   161    |    51     | 100 |
|淡黄 |   59    |    25     | 100 |

### 一些问题

#### 曾用方案
原始方案在彩色分割一步是在RGB空间下进行的，但对于红色队服、紫色队服等照片，衣服褶皱较多在阳光下会呈现不同的亮度。而由于RGB空间三个维度均与亮度耦合，导致使用方差不能将实际上队服上同色的区域分割出来。后将分割转换到HSV空间中，避免了亮度变化带来的梯度使得方差变大，队服内区域被mask掉的情况，效果变好。

#### 个例分析

从结果中可以发现，绿色和蓝色队服的两张图片换色效果最好，可以以假乱真，观感也十分自然舒适。
而粉色队服则会因为人物面部一些位置，在HSV空间中与队服比较相似，会出现一些不该出现的着色点。
而黄色队服由于拍摄环境在光度剧烈变化的区域，队服肩膀处可以观察到亮黄到暗黄灰黄的强烈梯度变化，而由于太阳光经衣物漫反射的复杂性，这会将大梯度引入到饱和度这一维度上，即使在HSV空间上进行分割，基于均值的方法也是不能工作的，这可能需要一些其他的处理。

值得注意的是，本次作业**约束了辅助分割的矩形个数为1**，如果可以**使用两个矩形区域**，一个用于取色，一个用于约束队服区域，会更好的解决人物面部以及背景误着色，也可以使用更aggressive的阈值条件，让队服着色效果更佳。