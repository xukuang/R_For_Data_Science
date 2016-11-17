### 7 探索性数据分析
#### 7.1 引言
这一章将讲述如何使用可视化和数据转化的方法系统地分析你的数据。这个过程在统计学上被称作探索性数据分析，简称EDA。它是一个迭代循环的过程。其中你需要：
1. 依据数据提出问题
2. 通过可视化，转化和模拟数据寻找答案
3. 通过你的了解重新定义你的问题或者提出新的问题。

EDA并不是一个有一系列严苛规则的过程。它更多的是一种思路。在EDA的初始阶段，你可以很自由的验证你的每一个想法。一些想法将会奏效，也有一些也会失败。当你继续分析的时候，你会锁定在一些特别具有生产力的领域，你甚至会写信和他人交流。

EDA是数据分析的一个重要部分，即使问题已经提交到你的手里，因为你常常需要检验数据的质量。数据清理只是EDA的一种实现方式。你需要确认你的数据是否满足你的要求。为了完成数据清理，你需要运用所有的EDA工具：可视化，数据转化和数据模拟。

##### 7.1.1 前提
在这一章我们将汇总你学到的所有关于dplyr和ggplot2的知识使用交换的方式针对数据提出问题，解决问题，接着提出新的问题。

```
library(tidyverse)
```


### 7.2 问题

EDA的目的是让你了解你的数据。了解你的数据的一个更加简单的方法是用问题来指导的你的分析。当你提出一个问题，这个问题会迫使你关注你数据集的特定部分，帮助你决定究竟使用图形、模型还是数据转化。

EDA是创意性过程的基础。如同大多数创意性过程，提出一个高质量的问题的关键是提出大量的小问题。在刚开始数据分析的时候很难提出深刻的问题，因为你不了解数据中包含的信息。另一方面，你每提出一个新问题都会让你从一个新的方面来理解这个数据，有机会有新的发现。如果你能跟进每一问题以及产生的新的问题，你会很快深入到数据当中最有趣的部分，并形成一系列发人深省的问题。

关于提出那些指导你研究的问题并没有统一的方法。无论如何，在探索数据时，两个问题的提出是非常有帮助的。这两个问题可以概括为：
1. 变量内部存在何种变异？
2. 变量间存在何种协变异？

这一章接下来的部分将讲述这两个问题。我将讲述什么是变异，协变异，同时用几种不同的方法回答每个问题。为了使讨论更加容易，我们需要定义一些术语：

* **变量**是你能够测量的数量，质量和性质。
* **值**是你所测量变量的描述。变量值在不同的测量中会发生变化。
* **观察**是在相同条件下的一系列测量(通常在一次观测中你能够同时对一个对象进行多个测量)。一个观察通常包含多个值，每个值对应不同的变量。有时，我也把观察称作数据点。
  **列表数据**是一系列值，每个值都与变量和观察相对应。如果每个值都放在它自己的单元格中，列表数据是非常整齐的，每一列对应一个变量，每一行组成一个记录。
  截至目前，你所遇到的所有数据都是整齐的。现实生活中，大多数数据往往并不是整齐的，因此在数据整理这一张我们将重新思考这些知识。

### 7.3 变异

变异是变量在多次测量中的值的趋势。现实生活中，你很容易的观察到变异。如果你两次测量任何一个连续型变量，你将会得到两个不同的值。即使你多次测量一个常量，如光速，这种情况仍然会出现。在每次测量当中都为会有少量的误差。如果你对不同的对象(例如，不同人眼睛的颜色)或者在不同的时间测量(电子在不同时刻的能量水平)，分类变量也会发生变化。每个变量都有它自己变异格局，能够反映非常有趣的信息。理解这种格局的最好方法是可视化变量值的分布。

#### 7.3.1 可视化分布

你如何可视化变量的分布依赖于变量是分类型变量和连续型变量。如果一个变量只能取一小组变量中的一个，那么这个变量是分类型变量。在R中，分类型变量通常被存储为因子型或者字符型变量。为了验证分类型变量的分布，使用条形图：

```
 ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
```

条的高度表示的是每个x值对应的观测的个数。你可以用dplyr::count()手动计算这些值的个数：

```
diamonds %>% count(cut)
```

如果一个变量可以取无穷有序值的任意一个，那么这个变量是连续型变量。数字和日期时间是两个连续型变量。为了验证连续型变量的分布，可以使用直方图：

```
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
```

你可以使用dplyr::count()和ggplot2::cut_width()计算这个。

```
diamonds %>% 
  count(cut_width(carat, 0.5))
```

直方图可以把x轴划分为均匀的条带，使用条形图的高度展示落在每个条带的观测值的个数。在上面图的中，最高的条带表明克拉重量落在0.25到0.75的条带内的的钻石的个数为30000。

你可以使用binwidth参数设置条形图的间隔的宽度。当处理直方图时，你通常可以尝试一系列条带的宽度，因为不同的条带宽度能展现出不同的格局。例如，这里如果我们仅处理克拉重量小于3克拉并选择更小的宽度，上面的图会怎么样呢？

```
smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
```

如果你希望覆盖多个直方图在同一个画布上，我建议你使用geom_freqploy()替换geom_histogram()。geom_freqploy()可以完成geom_histogram()相同的计算，但是这里用线来代替条形图的个数。覆盖线型图比条形图更容易理解。

```
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)
```

这种类型的图中还存在着一系列的挑战，在可视化分类变量和连续型变量中，我们将重新考虑这个问题。

现在你能够可视化变异，在图形中你能够发现什么呢？你能够提出什么类型的后续问题呢？我已经列出了一系列你在图形中会发现的有用的信息，以及每类信息背后各种后续问题。提出好的后续问题的关键是依赖于你的好奇心和怀疑态度。

#### 7.3.2 典型值

在条形图和直方图中，高的条带图表示的是一个变量的常见值，而低的条带表示的不太常见的值。没有的条带的地方表明这些值不存在于数据当中。为了把这些信息转化有用的问题，查找那些没有预料到的事情。

* 那些值最常见？为什么？
* 那些值比较少？为什么？这与你的预期相符吗？
* 你能够看出那些不常见的格局？什么能够解释这种格局？

例如，下面这个直方图能够显示几个有趣问题：

* 为什么<...>
* 为什么在每个极值右侧的钻石略多于极值右侧钻石？
* 没什么没有钻石的克拉重大于3克拉？

```
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
```

相似值的聚类表明在你的数据中小的分组存在。为了能够了解小的分组，提出这些问题：

* 不同的聚类之间是否相似？
* 不同的聚类之间是否不同？
* 如何解释和描述这些聚类？
* 这些聚类为什么会存在误导？

下面的直方图表示的是黄石国家公园老实泉的272次喷发的时间长度。喷发时间可以划分为两类。一个是2分钟左右的短喷发和4到5分分钟的长喷发。

```
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
```

上面的许多问题促使你探索分析不同变量之间的关系，例如，查看一个变量的值能否解释另一个变量的变化。我们就很快理解这些。

#### 7.3.3 不常见值

异常值在观测当中不常见。异常值的数据点不能模拟格局。有时候异常值可能是数据录入错误；而有时候异常值可能表明了新的科学。当你拥有大量的数据的时候，异常值有时在直方图中很难发现。例如，钻石数据集中y变量。异常值的唯一证据是y轴上异常广泛的限制。

```
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
```

在常见的条带中有如此多的常见值，以至于你几乎不能看到那些不常见的低矮的条带。为了能够更容易查看那些不常见的值，我们需要使用coor_cartesian()放大y轴小值。

```
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
```

当你要放大x轴，你可以在coord_cartesian()进行xlim设置。ggplot2中也有xlim()和ylim()函数，它们略有不同，能够抛出限制以外的数据。

这允许我们查看三个不常见的值：0，~30和~60。我们使用dplyr来找出它：

```
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unusual
#> # A tibble: 9 × 10
#>   carat       cut color clarity depth table price     x     y     z
#>   <dbl>     <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl> <dbl>
#> 1  1.00 Very Good     H     VS2  63.3    53  5139  0.00   0.0  0.00
#> 2  1.14      Fair     G     VS1  57.5    67  6381  0.00   0.0  0.00
#> 3  1.56     Ideal     G     VS2  62.2    54 12800  0.00   0.0  0.00
#> 4  1.20   Premium     D    VVS1  62.1    59 15686  0.00   0.0  0.00
#> 5  2.25   Premium     H     SI2  62.8    59 18034  0.00   0.0  0.00
#> 6  0.71      Good     F     SI2  64.1    60  2130  0.00   0.0  0.00
#> 7  0.71      Good     F     SI2  64.1    60  2130  0.00   0.0  0.00
#> 8  0.51     Ideal     E     VS1  61.8    55  2075  5.15  31.8  5.12
#> 9  2.00   Premium     H     SI2  58.9    57 12210  8.09  58.9  8.06
```

y变量是钻石三维的一个，单位是mm。我们知道钻石没有0mm的宽度，因此这些值是不正确的。我们也怀疑32mm和59mm的测量时不可靠。这些钻石超过1英尺的长度，却不没有成千上万的价值。

用是否包含异常值的数据重复你的分析非常好的办法。如果它们对结果影响微乎其微，你不知道它们为什么存在，利用没有缺失值的数据替换它们，进一步分析是非常合理的。无论如何，如果它们对数据产生很大的影响，你不应该在判断之前抛弃它们。你需要明白什么造成了这种现象(例如，数据输入错误)，也表明你需要在文章中删除它们。

#### 7.3.4 练习

1. 探索分析钻石的x，y和z的分布。你能获得怎样的信息？思考钻石，究竟长、宽和深度究竟哪个维度决定觉得这一个钻石？
2. 探索分析钻石价格的分布。你会发现那些不寻常或者奇怪的事情？(提示：仔细考虑条带的宽度，确信你尝试了一系列的值)
3. 0.99克拉重的钻石又多少个？1克拉重的钻石有多少个？你认为什么原因造成了这种差异？
4. 当你放大条形图的时候，比较和对比coor_cartesian()和xlim()或者ylim()。如果你不设置条带宽度会发生什么状况？如果你试图放大一半的条带会发生什么状况？

### 7.4 缺失值

如果在你的数据集中碰到了一些不常见值，为了能够接着分析，你会有两个想法。

1. 删除包含异常值的数据行

```
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
```

我并不推荐使用这种方法，因为只是其中的一个测量值是无效的，并不意味着所有的测量值都无效。此外，如果你有很少的数据，你对每个变量都使用相同的方法，你可能发现最终你的数据所剩无几。

2. 相反，我建议使用缺失值替换那些不常见的值。最简单的方法是使用mutate()函数对变量进行修改。你可以使用ifelse()函数用NA替换那些不常见的值。

```
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
```

ifelse()有三个参数。第一个参数test是一个逻辑型向量。如果test是TRUE，这个结果是第二个参数的值，反之，如果test是FALSE，结果是第三个参数的值。

ggplot2与R遵守相同的原则，缺失值并不会默认消失。当使用ggplot2对包含缺失值的数据画图的时候，缺失值并不明，。但是它会提醒缺失值被删除了。

```
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
#> Warning: Removed 9 rows containing missing values (geom_point).
```

为了避免这一警告，你可以设置 na.rm = TRUE:

```
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)
```

有时候你希望明白是否包含缺失数据的数据间的差异。例如， 在nycflights13::flights数据中，变量dep_time的缺失值表示的是取消的航班。因此你可以比较取消航班和非取消航班次数间的差异。你可以使用is.na()创建一个新的变量。

```
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
```

无论如何这个图的效果并不理想，因为相比取消的航班，有如此多的航班并没有取消。在下面一节，我们将使用一些方法改进这个比较。

#### 7.4.1 练习

1. 如果直方图中存在缺失值，会发生什么情况？条形图中存在缺失值，又会发生什么情况？两者有何差异？
2. na.ram在mean()和sum()函数中有什么作用？

### 7.5 协变异

如果说变异描述的变量内部的变化，协变量描述的变量之间的变化。协变异描述的是两个或多个变量之间的变化趋势。描述协变量的最好方法是可视化两个或多个变量之间的关系找出协变异。同样，如何画图也取决于变量的类型。

#### 7.5.1 分类型变量和连续型变量

探究连续型变量依据一个分类型变量的分布是比较常见的，如前面的频率多边形。geom_freqpoly()默认的设置对于这类比较并不是非常有用的，因为高度是个数。那意味着如果一个分组比其他的分组低，那是很难看出形状上的差异的。例如，我们可以分析一下钻石的价格随着其切工的变化。

```
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-20-1.png)

要找出它们分布之间的不同是很困难的，因为整体的个数有很大的差别。

```
ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-21-1.png)

为了能够方便的比较，我们需要改变一下y轴上显示的指标。我们使用密度替换个数，这里的密度是通过个数标准化得到的，每个频率图的面积都是1。

```
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-22-1.png)

关于这幅图有一些奇怪的地方。图中显示正常的钻石(最低品质)却有着最高的评价价格。这可能是由于频率多边形难以解释的。关于这幅图，还有大量的事情要做。

展示连续型变量依据一个分类型变量的分布的另一种方法是使用箱线图。线性图是一种查看变量值分布的简洁可视化方式，它也是统计上比较流行的图行。箱线图又下面几部分组成：

* 箱图，指示了分布到25%到75%的距离，这个距离就是我们熟知的四分位距离。箱图中部的线指示分布的中位数，即50%值。这三条形给出了分布的状况，或者是对称的，或者是偏向一边。
* 可视化点展示的是那些落在了距离箱图1.5倍距离以外。这些外面的点在单独画图时候并不容易发现。
* 线（或须）展示的从线的边界到最远非异常点的距离。

![img](http://r4ds.had.co.nz/images/EDA-boxplot.png)

接着我们使用geom_boxplot()看一下价格依据切工的分布。

```
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-24-1.png)

从箱线图中我们能看到较少的分布信息，但是它更加的紧凑，方便我们更加容易地比较分析。它也支持那个反常的发现质量更高的钻石有更低的均价。在练习中，要求你找出其中的原因。

切工是一个有序的因子。正常的要比好的差一些，比非常好的要更差，以此类推。许多分类变量并没有这样本质的顺序，因此，你为了能够展示更有效的信息，可能需要更改它们的顺序。为了做这个，你可以使用reorder()函数。

例如，就mpg数据集中的class变量而言。你可能对不同类型的一定油量的高速公路的英里如何变化比较感兴趣。

```
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-25-1.png)

为了更容易观察这个趋势，我们可以依据hwy的中位数来重新排序class。

```
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-26-1.png)

如果变量名过长，你可以把图像翻转90度，geom_boxplot()将有更好的效果。你可以通过coord_flip()来实现。

```
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-27-1.png)

##### 7.5.1.1 练习

1. 使用你学到的知识改进取消和未取消航班的出发时间的可视化效果。
2. 在钻石数据集中哪个变量对于预测钻石的价格最重要？那个变量与切工有何种关联程度？为什么这两种关系导致低质量的钻石有更高的价格。
3. 安装ggstance包，创建一个水平的箱线图。比较它与使用coor_flip()的区别。
4. 箱线图的一个问题是它们方便对一个小的数据集的展示，同时对异常值有一个大量的展示。字符值图(letter value plot)可以解决这个问题。安装lvplot包，尝试使用geom_lv()函数来展示价格同切工的分布。你能获得什么信息？如何描绘这些图？
5. 比较geom_violin()和一个分面的geom_histogram()，或个一个添加了颜色的geom_freqpoly()。每种方法有哪些优点和缺点。
6. 如果你的数据集比较小，使用geom_jitter()来查看连续变量和分类变量之间的关系是非常有用的。ggbeeswarm包提供了一系列与geom_jitter()相似的函数。列出它们并简单的描述它们是用来做什么的。

#### 7.5.2 两个分类型变量

为了可视化两个分类型变量间的协变异，你需要查看每种组合的个数。一个方法就是利用内建的geom_count()函数。

```
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-28-1.png)

图中每个圆环的大小代表了每个观测值的个数。协变异表明x和y之间存在着很强的关联。

```
diamonds %>% 
  count(color, cut)
#> Source: local data frame [35 x 3]
#> Groups: color [?]
#> 
#>   color       cut     n
#>   <ord>     <ord> <int>
#> 1     D      Fair   163
#> 2     D      Good   662
#> 3     D Very Good  1513
#> 4     D   Premium  1603
#> 5     D     Ideal  2834
#> 6     E      Fair   224
#> # ... with 29 more rows
```

另一种方法是使用dplyr包中的count计算：

```
diamonds %>% 
  count(color, cut)
#> Source: local data frame [35 x 3]
#> Groups: color [?]
#> 
#>   color       cut     n
#>   <ord>     <ord> <int>
#> 1     D      Fair   163
#> 2     D      Good   662
#> 3     D Very Good  1513
#> 4     D   Premium  1603
#> 5     D     Ideal  2834
#> 6     E      Fair   224
#> # ... with 29 more rows
```

使用geom_title()和fill属性来可视化。

```
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
    geom_tile(mapping = aes(fill = n))
```

![img](http://r4ds.had.co.nz/EDA_files/figure-html/unnamed-chunk-30-1.png)

如果分类变量是无序的，为了能够更加清楚地展示这些有趣的格局，你可能希望使用seriation包来同时排序行和列。对更大图，你可以尝试使用d3heatmap或者heatmaply包创建互动图。

##### 7.5.2.1 练习

1. 如何重新缩放上面的计数数据来更加清晰地显示切工依据颜色的分布，或者颜色依据切工的分布？
2. 使用geom_tile()结合dplyr包来分析不同月份和不同目的间航班延误的差异。什么原因使图像难以理解？如何改进？
3. 为什么在上面的例子中，aes(x = color, y = cut)的效果略好于aes(x = cut, y = color)？