setwd("data");
library(dplyr)

# Read the power consumption file
# The first row is the header
# na.strings = () replaces the mentioned string to NA
# colClasses changes the datatype of the columns as they are being read in

powerConsumption <- read.table("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?",
                               colClasses = c('character','character','numeric','numeric','numeric',
                                              'numeric','numeric','numeric','numeric'))

# Cast the Date column to Date datatype
powerConsumption$Date = as.Date(powerConsumption$Date,"%d/%m/%Y" )

# Choose data for a certain period
powerConsumption<- filter(powerConsumption, Date >="2007-02-01", Date <="2007-02-02")

# Concatenate the Date and Time columns and change the resultant column to Datetime type
powerConsumption$dateTime <- as.POSIXct(paste(powerConsumption$Date, powerConsumption$Time))

# PLOT 1
#-------
par(mfrow = c(1,1))

png("plot_1.png")

hist(powerConsumption$Global_active_power
             ,col="red"
             ,xlab="Global Active Power (kilowatts)"
             ,main="Global Active Power"
        )
dev.off()

