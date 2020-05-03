##This script loads data and generates "Plot 3", a line graph for the 3 energy sub metering over time from Feb 1 to Feb 2 2007

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

#PLOT 3
par(pty = "s", mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1)) #set size to square (for later printing) and panel to 1 by 1 
                                                            # and keep default margins

plot(x= subsetdf$datetime, y = subsetdf$Sub_metering_1, type= "l", col = "black", 
     xlab = NA, ylab = "Energy sub-metering")
lines(x= subsetdf$datetime, y = subsetdf$Sub_metering_2, col = "red")
lines(x= subsetdf$datetime, y = subsetdf$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = paste0("Sub_metering_",1:3), lty = 1)

#save plot as PNG
dev.print(png, file = "plot3.png", width = 480, height = 480)
dev.off()
