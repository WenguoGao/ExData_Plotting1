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

# plot 1 
png(file = "plot1.png", width = 480, height = 480)
hist(dt2$Global_active_power, col = "red", breaks = 12, 
     main = "Global Active power", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency")
dev.off()
