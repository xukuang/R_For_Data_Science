library(nycflights13)
library(dplyr)
library(ggplot2)

flights
# This data frame contains all 336,776 flights that departed from New York City in 2013. 
# The data comes from the US Bureau of Transportation Statistics

myflights = flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = distance %/% 100,
    sched_min = distance %% 100,
    distance = sched_hour + sched_min / 60
  )
head(myflights)
#############################
### 一个分类型变量的可视化###
#############################

ggplot(data = myflights) +
  geom_bar(mapping = aes(x = month))
#### 各个水平值的查看

myflights %>% count(month)

#############################
### 一个连续型变量的可视化###
#############################

myflights %>% ggplot() +
  geom_histogram(mapping = aes(x = distance), binwidth = 5)

myflights %>% 
  count(cut_width(distance, 5))

### 连续变量中不常见值的查看

myflights %>% ggplot() +
  geom_histogram(mapping = aes(x = distance), binwidth = 5) +
  coord_cartesian(ylim = c(0, 1500))

###################################
### 连续型变和分类型变量的可视化###
###################################


### 方法一:直方图和直方多边形
myflights %>% 
  ggplot(mapping = aes(distance)) + 
  geom_histogram(mapping = aes(fill = cancelled), binwidth = 5)

myflights %>% 
  ggplot(mapping = aes(distance)) + 
  geom_histogram(mapping = aes(y = ..density.., fill = cancelled), binwidth = 5)

myflights %>% 
  ggplot(mapping = aes(distance)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 5)

myflights %>% 
  ggplot(mapping = aes(distance)) + 
  geom_freqpoly(mapping = aes(y = ..density.., colour = cancelled),binwidth = 5)

### 方法二:箱线图
myflights %>% ggplot(mapping = aes(x = cancelled, y = distance)) +
  geom_boxplot()

#### 更改箱线图的顺序
myflights %>% ggplot(mapping = aes(x = cancelled, y = distance)) +
  geom_boxplot()


myflights %>% ggplot() +
  geom_boxplot(mapping = aes(x = reorder(cancelled, distance, FUN = median), y = distance))

#### 更改箱线图的显示方向
myflights %>% ggplot() +
  geom_boxplot(mapping = aes(x = reorder(cancelled, distance, FUN = median), y = distance)) + coord_flip()
