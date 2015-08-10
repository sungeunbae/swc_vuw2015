#args <- commandArgs(trailingOnly = TRUE)
#filename <-args[1]

filename <- "~/swc/capstone-novice-spreadsheet-biblio/data/bibliography.csv"
bibData <- read.csv(file=filename, header=FALSE,sep=",")
nrow(bibData)
head(bibData,5) #bibData[1:5,]
