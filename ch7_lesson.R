library(dplyr)
library(ggplot2)

diamonds

#############################
### 一个分类型变量的可视化###
#############################

diamonds %>% ggplot() +
  geom_bar(mapping = aes(x = cut))
#### 各个水平值的查看

diamonds %>% count(cut)

#############################
### 一个连续型变量的可视化###
#############################

diamonds %>% ggplot() +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  count(cut_width(carat, 0.5))

### 连续变量中不常见值的查看
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

###################################
### 连续型变和分类型变量的可视化###
###################################
### 方法一:直方图和直方多边形
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_histogram(mapping = aes(colour = cut, fill = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price,  y = ..density..)) + 
  geom_histogram(mapping = aes(colour = cut, fill = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price,  y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

### 方法二:箱线图
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

#### 更改箱线图的顺序
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

#### 更改箱线图的显示方向
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
###########################
### 两个连续变量的可视化###
###########################
### 点图
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
### 方形图
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

