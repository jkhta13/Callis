library(reshape2)
library(ggplot2)

imageData <- read.csv("/Users/jkta/existing-data-collection/Arabidopsis Data/Rep 3 Data (10.25.13 - 12.24.13)/Rep 3 Image Analysis.csv", header = T)
genoData <- read.csv("/Users/jkta/existing-data-collection/Arabidopsis Data/Rep 3 Data (10.25.13 - 12.24.13)/plant id and position-set3 (sha_col).csv", header = T)
WWRData <- read.csv("/Users/jkta/existing-data-collection/Arabidopsis Data/Rep 3 Data (10.25.13 - 12.24.13)/Rep 3 WWR Schedule.csv", header = T)

colnames(WWRData) <- c("Flat_Number", "20131108", "20131113")

imgData <- imageData
geno <- genoData
WWR <- melt(WWRData)

for (i in 1:length(WWR$Flat_Number)) {
  j <- substr(WWR$Flat_Number[i], 3, 3)
  WWR$Flat_ID[i] <- paste(j, WWR$value[i], WWR$variable[i], sep = "_")
}

for (i in 1:length(imgData$Tray_Number)) {
  j <- substr(imgData$Image_Name[i], 18, 18)
  imgData$Flat_ID[i] <- paste(j, imgData$Tray_Number[i], imgData$Date[i], sep = "_")
}

image <- merge(WWR, imgData, by = "Flat_ID")

for (i in 1:length(image$Flat_ID)) {
  j <- as.numeric(substr(image$Flat_Number[i], 3, 3))
  z <- as.numeric(substr(image$Flat_Number[i], 5, 6))
  image$ID[i] <- paste(j, z, image$Plant_Position[i], sep = "_")
}

for (i in 1:length(geno$Flat.number)) {
  k <- as.numeric(substr(geno$Flat.number[i], 3, 3))
  j <- as.numeric(substr(geno$Flat.number[i], 5, 6))
  geno$ID[i] <- paste(k, j, geno$Position.in.flat[i], sep = "_")
}

data <- merge(geno, image, by = "ID")
data[grep("c1|c2|c3", data$Image_Name), "Treatment"] <- "Shade"
data[grep("c4|c5|c6", data$Image_Name), "Treatment"] <- "Sun"
data[grep("L", data$Flat_Number), "Nutrient_Level"] <- "Low"
data[grep("H", data$Flat_Number), "Nutrient_Level"] <- "High"
