
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


# PLOT 4
#-------

par(mfrow = c(2,2))

png("plot_4.png")

plot(powerConsumption$Global_active_power~powerConsumption$dateTime, type="l"
     ,ylab="Global Active Power (kilowatts)")


plot(powerConsumption$Voltage~powerConsumption$dateTime, type="l"
     ,ylab="Voltage")


with(powerConsumption,
     {
       plot(powerConsumption$Sub_metering_1~powerConsumption$dateTime, type="l", col="Black",
            ylab="Global Active Power (kilowatts)",
            xlab="")
       lines(powerConsumption$Sub_metering_2~powerConsumption$dateTime, type="l", col="Red")
       lines(powerConsumption$Sub_metering_3~powerConsumption$dateTime, type="l", col="Blue")
     }
)
legend("topright", 
       col=c("black", "blue", "red"),
       lwd=c(1,1,1),
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

plot(powerConsumption$Global_reactive_power~powerConsumption$dateTime, type="l"
     ,ylab="Global Reactive Power (kilowatts)")

dev.off()
