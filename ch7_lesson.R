library(dplyr)
library(ggplot2)

diamonds

#############################
### һ�������ͱ����Ŀ��ӻ�###
#############################

diamonds %>% ggplot() +
  geom_bar(mapping = aes(x = cut))
#### ����ˮƽֵ�Ĳ鿴

diamonds %>% count(cut)

#############################
### һ�������ͱ����Ŀ��ӻ�###
#############################

diamonds %>% ggplot() +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  count(cut_width(carat, 0.5))

### ���������в�����ֵ�Ĳ鿴
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

###################################
### �����ͱ�ͷ����ͱ����Ŀ��ӻ�###
###################################
### ����һ:ֱ��ͼ��ֱ�������
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_histogram(mapping = aes(colour = cut, fill = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price,  y = ..density..)) + 
  geom_histogram(mapping = aes(colour = cut, fill = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price,  y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

### ������:����ͼ
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

#### ��������ͼ��˳��
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

#### ��������ͼ����ʾ����
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
###########################
### �������������Ŀ��ӻ�###
###########################
### ��ͼ
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
### ����ͼ
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))
