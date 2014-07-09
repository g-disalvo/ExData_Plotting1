## This provides a set of functions to operate on the UC Irvine Machine Learning Repository "Individual household electric power consumption Data Set" (http://archive.ics.uci.edu/ml/).
## It allows reading and plotting of Global Active Power data.

## GD - 7/9/14 - initial release

## usage: readData(refresh)
##   Reads data from locally or Coursera website (as required), formats, and subsets according to the definition in https://class.coursera.org/exdata-004/human_grading/view/courses/972141/assessments/3/submissions

## parameters:
##   refresh        force refresh of the data - optional (if omitted, the data is only read if the "project1.zip" file doesn't exist in the working directory)

## examples:
## readData()

readData <- function(refresh = FALSE) {
    # Test whether data already exists or refresh is called for
    if (!(file.exists("project1.zip")) | refresh) {
        print("Downloading data set...") # inform user
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "project1.zip")  # download file and save locally
    }
    print("Reading raw data...")
    dataRaw <- read.table(unz("project1.zip", "household_power_consumption.txt"), header=TRUE, sep=";", na.strings="?")   # read data from zipped file
    print("Processing data...")
    dataRaw$DateTime <- as.POSIXct(paste(dataRaw$Date, dataRaw$Time), format="%d/%m/%Y %H:%M:%S") # create a new field with formatted data/time
    dataSubset <- subset(dataRaw, DateTime >= strptime("2007-02-01", "%Y-%m-%d") & DateTime < strptime("2007-02-03", "%Y-%m-%d"))  # subset data per problem statement
    invisible(dataSubset)    # return dataset without printing
}

## usage: plot4()
##   Plots a multiple graphs according to the format shown in Plot 4 of https://class.coursera.org/exdata-004/human_grading/view/courses/972141/assessments/3/submissions.

## parameters:
##   None

## examples:
## plot4()

plot4 <- function(dataset) {
    par(mfrow = c(2,2))
    plot2(ds)
    plot(ds$DateTime, ds$Voltage, type="l", xlab="datetime", ylab="Voltage")
    plot3(ds)
    plot(ds$DateTime, ds$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
}

## usage: makePng(filename, plotFunctionName)
##   Creates a 480 x 480 px PNG file containing plot data

## parameters:
##   filename           for storing the plot
##   plotFunctionName   function to create the plot (NOTE: this is always called with DS as argument)

## examples:
## makePng("plot1.png", "plot1")

makePng <- function(filename, plotFunctionName){
    pf <- match.fun(plotFunctionName)
    png(filename, width = 480, height = 480)
    pf(ds)
    dev.off()
}