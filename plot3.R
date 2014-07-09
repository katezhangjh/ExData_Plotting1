### read file in #####
powercomp<-read.table("household_power_consumption.txt",header = TRUE, sep = ";", dec = ".",stringsAsFactors=FALSE)

str(powercomp)

### change class of the column to date,character,numeric,numeric,numeric,numeric,integer,integer,integer)
powerconsump<-transform(powercomp,Date=as.Date(Date,"%d/%m/%Y"),
                        Global_active_power=as.numeric(Global_active_power),
                        Global_reactive_power=as.numeric(Global_reactive_power),Voltage=as.numeric(Voltage),
                        Global_intensity=as.numeric(Global_intensity),Sub_metering_1=as.integer(Sub_metering_1),
                        Sub_metering_2=as.integer(Sub_metering_2),Sub_metering_3=as.integer(Sub_metering_3))
str(powerconsump)


### get the subset data for plotting 2007-02-01 and 2007-02-02 ####
mypower<-subset(powerconsump,Date=="2007-02-01" | Date == "2007-02-02")
mypower<-transform(mypower,Time=strptime(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"))
mypower$datetime<-mypower$Time
mypower$Date<-NULL
mypower$Time<-NULL
mypower$Global_intensity<-NULL

str(mypower)

### plot the third graph
png("plot3.png")
with(mypower,plot(datetime,Sub_metering_1,type="l",col="black",xlab=" ",ylab="Energy sub metering"))
with(mypower,lines(datetime,Sub_metering_2,col="red"))
with(mypower,lines(datetime,Sub_metering_3,col="blue"))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),lwd=1,cex=0.8)
dev.off()


