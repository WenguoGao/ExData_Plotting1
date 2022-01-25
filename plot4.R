library(dplyr)
library(sqldf)
library(lubridate)

## download the data file
if(!file.exists("./data")) {dir.create("./data")}
Url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(Url, destfile = "./data/Electric_power_consumption.zip", method = "curl")
unzip("./data/Electric_power_consumption.zip")

# data for plot
dt = read.csv.sql("./household_power_consumption.txt", header = T, sep = ";",
                  sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",
                  colClasses = c("character", "character", "numeric", "numeric",
                                 "numeric", "numeric", "numeric", "numeric",
                                 "numeric"))

dt1 = tbl_df(dt)
dt1[dt1 == "?" ] = NA

dt2 = mutate(dt1, Datetime = strptime(paste(Date, Time, sep = " "), "%d/%m/%Y %H:%M:%S") ) %>% 
        select(-(Date:Time)) %>%
        relocate(Datetime, .before = Global_active_power)

# plot 4
png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2), mar = c(4, 4, 4, 1), oma = c(0, 0, 0, 0))
with(dt2, 
        {plot(Datetime, Global_active_power, type = "l", 
           ylab = "Global Active Power", xlab = "", 
           cex.lab = 0.7, cex.axis = 0.7) 
             
        plot(Datetime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage", 
             cex.lab = 0.7, cex.axis = 0.7)           
             
        plot(Datetime, Sub_metering_1, type = "l", 
               ylab = "Energy sub metering", xlab = "", 
               col = "black", cex.lab = 0.7, cex.axis = 0.7 )
                lines(dt2$ Datetime, dt2$Sub_metering_2, type = "l", 
                   ylab = "Energy sub metering", xlab = "", 
                   col = "red" )
                lines(dt2$ Datetime, dt2$Sub_metering_3, type = "l", 
                   ylab = "Energy sub metering", xlab = "", 
                   col = "blue" )
                legend("topright", lty =1, col = c("black", "red", "blue"), 
                    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                    cex = 0.6)
        
        plot(Datetime, Global_reactive_power, type = "l", 
             xlab = "datetime", ylab = "Global_reactive_power", 
             cex.lab = 0.7, cex.axis = 0.7)
})
dev.off()






