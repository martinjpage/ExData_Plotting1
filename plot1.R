##This script loads data and generates "Plot 1", a histogram of global active power for Feb 1 and Feb 2 2007

#load libraries
library(data.table)
library(lubridate)
library(dplyr)

#read data
powerdf <- fread(file = "household_power_consumption.txt", header = TRUE, na.strings = "?")

#add new column for combined date-time
powerdf$datetime <- dmy_hms(with(powerdf, paste(Date, Time)))

#format date and time variables
powerdf$Date <- dmy(powerdf$Date) 
powerdf$Time <- hms(powerdf$Time) 

#subset data to include only 2 days - 1 Feb and 2 Feb 2007
date_index <- c(dmy("01-02-2007"), dmy("02-02-2007"))
subsetdf <- powerdf %>% filter(Date %in% date_index)

#PLOT 1
par(pty = "s", mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1)) #set size to square (for later printing) and panel to 1 by 1 
                                                            # and keep default margins

hist(subsetdf$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)",
     col = "darkorange2")

#save plot as PNG
dev.print(png, file = "plot1.png", width = 480, height = 480)
dev.off()
