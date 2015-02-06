plot1 <- function()
{
# This code "Exploratory Data Analysis" Project 1 and Plot 1
# Overall goal here is to examine how household energy usage varies over a 2-day period 
# in February, 2007. 

# Read the Electric power consumption file and assign to a variable. Missing values are coded as ? are excluded 
# The file was downloaded to the system working directory folder EG/Week 1/  
powerc <- read.table("EG/Week 1/household_power_consumption.txt", sep = ";", na.strings="?", header=TRUE)

# convert the Date to Date classe in R using as.Date() functions
powerc$Date <- as.Date(powerc$Date,format = "%d/%m/%Y")

# Using data from the dates 2007-02-01 and 2007-02-02
pcdate <- powerc[(powerc$Date=="2007-02-01") | (powerc$Date=="2007-02-02"),]

# Change Global_Active_power to numeric
pcdate$Global_Active_power <- as.numeric(as.character(pcdate$Global_active_power))

# combine Date and Time
pcdate$Date_Time <- paste(pcdate$Date, pcdate$Time)

# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename= "plot1.png", width = 480, height = 480, units = "px", bg ="white")

par(mar = c(6, 6, 5, 4))

hist(pcdate$Global_active_power, col ="red", main = "Global Active Power", xlab = "Global Active Power(kilowatts)")



dev.off()
}
