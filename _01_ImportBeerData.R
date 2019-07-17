# data file 'recipeData.csv' should be in working directory
# if not, download from:
# https://www.kaggle.com/jtrofe/beer-recipes


# read in beer data
beer <- read.csv(
    "recipeData.csv",
    stringsAsFactors = FALSE,
    na.strings = "N/A"
)
# explore data
head(beer)
length(unique(beer$BeerID))
any(is.na(beer$BeerID))
str(beer)
# compare to definitions from Kaggle


# look at distribution of records by ABV - what does this mean?
quantile(beer$ABV, seq(0, 1, .01), type = 3)
# what is the 25th percentile? median? 95th percentile?
# beers with > 20% alcohol???
library(dplyr)
x <- beer %>%
    filter(ABV > 20)
View(x)


# look at distribution for some of the character variables
summary(factor(beer$SugarScale))
summary(factor(beer$SugarScale))/nrow(beer)
summary(factor(beer$BrewMethod))
summary(factor(beer$BrewMethod))/nrow(beer)
table(beer$BrewMethod, beer$SugarScale)
length(unique(beer$PrimingMethod))
mean(is.na(beer$PrimingMethod))
table(is.na(beer$PrimingMethod), is.na(beer$PrimingAmount))


# remove some unneccesary fields
b <- beer %>%
    select(
        -URL,
        -StyleID,
        -Size.L.,
        -PrimingMethod,
        -PrimingAmount,
        -UserId
    )
head(b)


# save dataset in RData file
save(list = c("b"), file = "_01_ImportBeerData.RData")
