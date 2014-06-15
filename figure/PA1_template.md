My first markdown file - Activity Analysis Report
========================================================

This report is to summarize various statistics and explore data pattern via graphs based on given activity data. I am going to load data, have a dataframe object-activity.


```r
activity<-read.csv("activity.csv",header=T,sep=",",stringsAsFactors=F)
str(activity)
```

```
## 'data.frame':	17568 obs. of  3 variables:
##  $ steps   : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ date    : chr  "2012-10-01" "2012-10-01" "2012-10-01" "2012-10-01" ...
##  $ interval: int  0 5 10 15 20 25 30 35 40 45 ...
```

Once data is loaded,I will make a histogram of the total number of steps taken each day.Fist, summarize daily steps to form new dataframe-activity.total, and secondly, use ggplot to draw distribution of steps.


```r
activity.total<-data.frame(tapply(activity$steps,(as.factor(activity$date)),function(x)sum(x,na.rm=T)))                             
activity.total$date<-as.character(rownames(activity.total))
colnames(activity.total)<-c("totalsteps","date")
library("ggplot2")
ggplot(activity.total,aes(x=as.Date(date),y=totalsteps))+geom_bar(stat="identity")+xlab("date")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

Then do calculation on the mean and median total number of steps taken per day,mean stored in variable mean


```r
mean=mean(activity.total$totalsteps)
mean
```

```
## [1] 9354
```

```r
median(activity.total$totalsteps)
```

```
## [1] 10395
```

I will make a plot to show average daily activity pattern and return the time interval of the maximum number of steps.Summarize interval steps and average them by 61 days, then plot the relationship between average steps and interval.


```r
activity.interval<-data.frame(tapply(activity$steps,(as.factor(activity$interval)),
                                     function(x)sum(x,na.rm=T)/length(activity.total$date)))
activity.interval$interval<-as.character(rownames(activity.interval))
colnames(activity.interval)<-c("averagesteps","interval")
with(activity.interval,plot(interval,averagesteps,type="l"))
```

![plot of chunk pattern](figure/pattern.png) 


```r
with(activity.interval,interval[which(averagesteps==max(averagesteps))])
```

```
## [1] "835"
```

Calculate and report the total number of missing values in the dataset, in this case, I use complete.cases function.


```r
sum(!complete.cases(activity))
```

```
## [1] 2304
```

Devise a strategy for filling in all of the missing values in the dataset,in this case,strategy is to use overall daily mean to get interval mean, new dataset with filled value is named as activity.compute


```r
activity.compute<-activity
n=length(levels(as.factor(activity$interval)))
intervalmean=mean/n
activity.compute$steps<-ifelse(!complete.cases(activity.compute),intervalmean,activity$steps)
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. mean is significantly larger, but median remain unchanged.


```r
ac.comp.total<-data.frame(tapply(activity.compute$steps,(as.factor(activity.compute$date)),
                                  function(x)sum(x)))
ac.comp.total$date<-as.character(rownames(ac.comp.total))
colnames(ac.comp.total)<-c("totalsteps","date")
ggplot(ac.comp.total,aes(x=as.Date(date),y=totalsteps))+geom_bar(stat="identity")+xlab("date")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 


```r
mean(ac.comp.total$totalsteps)
```

```
## [1] 10581
```

```r
median(ac.comp.total$totalsteps)
```

```
## [1] 10395
```

Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.


```r
weekday<-weekdays(as.Date(activity.compute$date))
wdays<-ifelse((weekday=="Saturday"| weekday=="Sunday"),"weekend","weekday")
activity.compute$wdays<-wdays
df.wdays<-data.frame(table(wdays))
df.wdays
```

```
##     wdays  Freq
## 1 weekday 12960
## 2 weekend  4608
```

Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).Summarize data according to interval & weekdays factor, and divide by total days.


```r
ac.comp.interval<-aggregate(steps~interval+wdays,data=activity.compute,sum)
wd.count<-df.wdays[1,2]/length(activity.interval$interval)
wk.count<-df.wdays[2,2]/length(activity.interval$interval)
ac.comp.interval$averagesteps<-ifelse((ac.comp.interval$wdays=="weekday"),
                                      ac.comp.interval$steps/wd.count,
                                      ac.comp.interval$steps/wk.count)
library("lattice")
xyplot(averagesteps~interval|wdays,
       data=ac.comp.interval,
       type="l",  
       xlab=c("interval"),
       ylab=c("Number of steps"),
       layout=c(1,2)
)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 