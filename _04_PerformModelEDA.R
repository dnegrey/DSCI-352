# load clean beer RData
load("_03_CreateModelingDataset.RData")


# load packages needed
library(dplyr)
library(miscTools)


# limit to build subset (important)
x <- bm %>%
    filter(BuildValidate == "Build") %>%
    select(
        -BeerID,
        -RandomNumber,
        -BuildValidate
    )


# create a model EDA object using miscTools
help("modelEDA")
xm <- modelEDA(
    x = x,
    yname = "FlagIPA",
    ytype = 1,
    bin.numBins = 20,
    bin.minPct = 1,
    bin.maxPct = 95,
    variable_cluster.na.rm = FALSE
)


# create a model EDA report using miscTools
help("modelEDA_Report")
modelEDA_Report(
    x = xm,
    projectLabel = "Logistic IPA Model EDA"
)


# examine the report
# which variables look good to include in the model?


# IBU, ABV, Color (transform), PrimaryTemp (recode NA to 17)
# OG, BoilGravity (recode NA to 1.043)
x <- x %>%
    mutate(
        Color = ifelse(
            Color > 22, 0,
            ifelse(
                Color <= 11, Color,
                11 - (Color - 11)
            )
        ),
        PrimaryTemp = ifelse(is.na(PrimaryTemp), 17, PrimaryTemp),
        BoilGravity = ifelse(is.na(BoilGravity), 1.043, BoilGravity)
    )
# check correlation matrix
xc <- cor(x[c("IBU", "ABV", "Color", "PrimaryTemp", "OG", "BoilGravity")])
print(xc)
library(ggplot2)
qplot(
    data = x,
    x = OG,
    y = BoilGravity,
    geom = "point"
)
# look back at eda report - stick with OG


# create final dataset to use in model
bmx <- bm %>%
    mutate(
        Color = ifelse(
            Color > 22, 0,
            ifelse(
                Color <= 11, Color,
                11 - (Color - 11)
            )
        ),
        PrimaryTemp = ifelse(is.na(PrimaryTemp), 17, PrimaryTemp)
    ) %>%
    select(
        BeerID,
        IBU,
        ABV,
        Color,
        PrimaryTemp,
        OG,
        FlagIPA,
        BuildValidate
    )
lapply(split(bmx, bmx$BuildValidate), function(v){mean(v$FlagIPA)})


# save dataset in RData file
save(list = c("bmx"), file = "_04_PerformModelEDA.RData")
