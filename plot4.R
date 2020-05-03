##This script loads data and generates "Plot 4", a panel of 4 plots, from left to right and top to bottom:
##Plot 1: a line graph of global active power over time from Feb 1 to Feb 2 2007
##Plot 2: a line graph of voltage over time from Feb 1 to Feb 2 2007
##Plot 3: a line graph for the 3 energy sub metering over time from Feb 1 to Feb 2 2007
##Plot 4: a line graph of global reactive power over time from Feb 1 to Feb 2 2007

#load libraries
library(data.table)
library(lubridate)
library(dplyr)

#read data
powerdf <- fread(file = "household_power_consumption.txt", header = TRUE, na.strings = "?")

#add new column for combined date-time
powerdf$datetime <- dmy_hms(with(powerdf, paste(Date, Time)))

#format original date and time variables
powerdf$Date <- dmy(powerdf$Date) 
powerdf$Time <- hms(powerdf$Time) 

#subset data to include only 2 days - 1 Feb and 2 Feb 2007
date_index <- c(dmy("01-02-2007"), dmy("02-02-2007"))
subsetdf <- powerdf %>% filter(Date %in% date_index)

#PLOT 4
par(pty = "s", mfrow = c(2,2), mar = c(4,3,1,0)) #set size to square and panel to 2 by 2 and reduce margin size

#sub plot 1 (code from plot2.R with modified ylab)
plot(x= subsetdf$datetime, y = subsetdf$Global_active_power, type= "l", 
     xlab = NA, ylab = "Global Active Power")

#sub plot 2
plot(x = subsetdf$datetime, y = subsetdf$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

#sub plot 3 (code from plot3.R with modified legend border)
plot(x= subsetdf$datetime, y = subsetdf$Sub_metering_1, type= "l", col = "black", 
     xlab = NA, ylab = "Energy sub-metering")
lines(x= subsetdf$datetime, y = subsetdf$Sub_metering_2, col = "red")
lines(x= subsetdf$datetime, y = subsetdf$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = paste0("Sub_metering_",1:3), lty = 1, bty = "n")

#sub plot 4
plot(x = subsetdf$datetime, y = subsetdf$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global Reactive Power")

#save panel plot as PNG
dev.print(png, file = "plot4.png", width = 480, height = 480)
dev.off()
