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
### һ�������ͱ����Ŀ��ӻ�###
#############################

ggplot(data = myflights) +
  geom_bar(mapping = aes(x = month))
#### ����ˮƽֵ�Ĳ鿴

myflights %>% count(month)

#############################
### һ�������ͱ����Ŀ��ӻ�###
#############################

myflights %>% ggplot() +
  geom_histogram(mapping = aes(x = distance), binwidth = 5)

myflights %>% 
  count(cut_width(distance, 5))

### ���������в�����ֵ�Ĳ鿴

myflights %>% ggplot() +
  geom_histogram(mapping = aes(x = distance), binwidth = 5) +
  coord_cartesian(ylim = c(0, 1500))

###################################
### �����ͱ�ͷ����ͱ����Ŀ��ӻ�###
###################################


### ����һ:ֱ��ͼ��ֱ�������
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

### ������:����ͼ
myflights %>% ggplot(mapping = aes(x = cancelled, y = distance)) +
  geom_boxplot()

#### ��������ͼ��˳��
myflights %>% ggplot(mapping = aes(x = cancelled, y = distance)) +
  geom_boxplot()


myflights %>% ggplot() +
  geom_boxplot(mapping = aes(x = reorder(cancelled, distance, FUN = median), y = distance))

#### ��������ͼ����ʾ����
myflights %>% ggplot() +
  geom_boxplot(mapping = aes(x = reorder(cancelled, distance, FUN = median), y = distance)) + coord_flip()