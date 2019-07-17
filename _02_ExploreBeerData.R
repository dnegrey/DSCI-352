# load clean beer RData
load("_01_ImportBeerData.RData")


# explore data
head(b)


# are the gravity of wort fields correlated?
cor(b$OG, b$FG)
library(ggplot2)
qplot(
    data = b,
    x = OG,
    y = FG,
    geom = "point"
)
# based on what these fields mean, how can we interpret this relationship?


# visualize the distribution of beers by ABV
# many ways but utilize functions in `miscTools` package
library(miscTools)
x <- univariateSummary(b$ABV, numBins = 20)
print(x)
relativeHistogram(x, "Alcohol by Volume")
# long tail after ~15%, so re-visualize between 2 and 15%
library(dplyr)
x <- b %>%
    filter(ABV >= 2 & ABV <= 15)
# what % of records remain?
nrow(x)/nrow(b)
x <- univariateSummary(x$ABV, numBins = 20)
relativeHistogram(x, "Alcohol by Volume")
# how much of our data has between 5.25% and 7.2% ABV?
# modify x to show cumulative percent
print(x)
x$yagg <- cumsum(x$Percent)
# visualize relative and cumulative frequency
univariateGraph(
    data = x,
    xLabel = "Alcohol by Volume",
    yLabel = "Cumulative Frequency",
    yType = "pct",
    yDigits = 1,
    barColor = "#D7D7D7",
    lineColor = "#0A304E"
)
# approximate the 95th percentile in ABV using this graph - what does it mean?


# what are the darkest 10 beer styles?
x <- b %>%
    group_by(Style) %>%
    summarise(NumBeers = n(),
              AvgColor = mean(Color)) %>%
    data.frame() %>%
    arrange(desc(AvgColor))
head(x, n = 20)
x <- head(x, n = 10)
barGraph(
    x = x$Style,
    y = x$AvgColor,
    mainTitle = "<b>Darkest Beers by Style</b>",
    yLabel = "Average Color",
    yDigits = 1,
    barColor = "#D7D7D7",
    lineColor = "#0A304E",
    lineWidth = 1,
    orderBy = "y",
    orderDesc = TRUE,
    horizontal = TRUE
)
# what stands out about all of these?
