---
title: "PA1_template.Rmd"
author: "Rohith Shankar"
date: "6/7/2020"
output: html_document
---



## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


```r
activity <- read.csv(".\\data\\activity.csv", sep=",", header=TRUE)
```

```
## Warning in file(file, "rt"): cannot open file '.\data\activity.csv': No such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```


```r
#2. Histogram of the total number of steps taken each day

library(dplyr)
daily_steps <- summarize(group_by(activity, date), total_steps=sum(steps))
head(daily_steps)
```

```
## # A tibble: 6 x 2
##   date       total_steps
##   <fct>            <dbl>
## 1 2012-10-01           0
## 2 2012-10-02         126
## 3 2012-10-03       11352
## 4 2012-10-04       12116
## 5 2012-10-05       13294
## 6 2012-10-06       15420
```

```r
par(mfrow = c(1,1)) # Define the matrix of the plots (only 1 plot here)

hist(daily_steps$total_steps, col="green"
                            , breaks=10 
                            , main = "Total Daily Steps"
                            , xlab="Daily Steps")  
```

![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23-1.png)



```r
#3. Mean and median steps taken each day
mean_steps <- summarize(group_by(activity, date), mean_steps=mean(steps))
median_steps <- summarize(group_by(activity, date), median_steps=median(steps))
```


```r
#4. Time series plot of the average number of steps taken

interval_avg_steps <- summarize(group_by(activity, interval), avg_steps=mean(steps,na.rm=TRUE))

plot(interval_avg_steps, type= "line", col=4, main="Time Series plot of average steps",
     xlab="Time",ylab="Average Number of Steps")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first character
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25-1.png)


```r
#5. The five minute interval that on average, contains the maximum number of steps

max(interval_avg_steps$avg_steps)
```

```
## [1] 179.1311
```

```r
max_mean_steps <-filter(interval_avg_steps, avg_steps == max(interval_avg_steps$avg_steps))
max_mean_steps$interval[1]
```

```
## [1] 835
```


```r
#6. Code to describe and show a strategy or imputing missing data
colSums(is.na(activity))
```

```
##     steps      date  interval DayOfWeek 
##         0         0         0         0
```

```r
activity[is.na(activity)]=0
```


```r
#7. Histogram of the total number of steps taken each day after missing values are imputed

daily_steps <- summarize(group_by(activity, date), total_steps=sum(steps))
head(daily_steps)
```

```
## # A tibble: 6 x 2
##   date       total_steps
##   <fct>            <dbl>
## 1 2012-10-01           0
## 2 2012-10-02         126
## 3 2012-10-03       11352
## 4 2012-10-04       12116
## 5 2012-10-05       13294
## 6 2012-10-06       15420
```

```r
par(mfrow = c(1,1)) # Define the matrix of the plots (only 1 plot here)

hist(daily_steps$total_steps, col="green"
     , breaks=10 
     , main = "Total Daily Steps after imputation of NAs"
     , xlab="Daily Steps")  
```

![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28-1.png)


```r
# 8. Panel plot comparing the average number of steps taken per 5-minute interval 
#    across weekdays and weekends

activity$DayOfWeek <- weekdays(as.Date(activity$date))
head(activity)
```

```
##   steps       date interval DayOfWeek
## 1     0 2012-10-01        0    Monday
## 2     0 2012-10-01        5    Monday
## 3     0 2012-10-01       10    Monday
## 4     0 2012-10-01       15    Monday
## 5     0 2012-10-01       20    Monday
## 6     0 2012-10-01       25    Monday
```

```r
activity_weekdays <- filter(activity, DayOfWeek %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"))
activity_weekends <- filter(activity, DayOfWeek %in% c("Saturday", "Sunday"))
head(activity_weekdays)
```

```
##   steps       date interval DayOfWeek
## 1     0 2012-10-01        0    Monday
## 2     0 2012-10-01        5    Monday
## 3     0 2012-10-01       10    Monday
## 4     0 2012-10-01       15    Monday
## 5     0 2012-10-01       20    Monday
## 6     0 2012-10-01       25    Monday
```

```r
mean_steps_wd <- summarize(group_by(activity_weekdays, interval), mean_steps=mean(steps))
head(mean_steps_wd)
```

```
## # A tibble: 6 x 2
##   interval mean_steps
##      <int>      <dbl>
## 1        0     2.02  
## 2        5     0.4   
## 3       10     0.156 
## 4       15     0.178 
## 5       20     0.0889
## 6       25     1.31
```

```r
mean_steps_we <- summarize(group_by(activity_weekends, interval), mean_steps=mean(steps))
head(mean_steps_we)
```

```
## # A tibble: 6 x 2
##   interval mean_steps
##      <int>      <dbl>
## 1        0       0   
## 2        5       0   
## 3       10       0   
## 4       15       0   
## 5       20       0   
## 6       25       3.25
```

```r
par(mfrow = c(1,2)) # Define the matrix of the plots (only 1 plot here)

plot(mean_steps_wd$interval, mean_steps_wd$mean_steps, type="line"
                             ,main="Weekdays",xlab="Interval", ylab="Average Steps", col=10)
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first character
```

```r
plot(mean_steps_we$interval, mean_steps_we$mean_steps, type="line"
                            ,main="Weekends", xlab="Interval", ylab="Average Steps")
```

```
## Warning in plot.xy(xy, type, ...): plot type 'line' will be truncated to first character
```

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-1.png)

