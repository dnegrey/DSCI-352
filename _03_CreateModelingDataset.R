# load clean beer RData
load("_01_ImportBeerData.RData")


# goal: predict likelihood that a beer is an IPA based on other beer attributes


# create binary target ("dependent variable")
# flag beers as IPA (based on Style)
b$FlagIPA <- grepl(
    pattern = "IPA",
    x = b$Style,
    fixed = TRUE
)
# print a table summarizing style and flag just to double check
table(b$Style, b$FlagIPA)


# convert character fields to integer binary flags for each level
summary(factor(b$SugarScale))
b$SugarScale_Plato <- as.integer(b$SugarScale == "Plato")
b$SugarScale_SpecificGravity <- as.integer(b$SugarScale == "Specific Gravity")
table(b$SugarScale_Plato, b$SugarScale_SpecificGravity)
summary(factor(b$BrewMethod))
b$BrewMethod_AllGrain <- as.integer(b$BrewMethod == "All Grain")
b$BrewMethod_BIAB <- as.integer(b$BrewMethod == "BIAB")
b$BrewMethod_Extract <- as.integer(b$BrewMethod == "extract")
b$BrewMethod_PartialMash <- as.integer(b$BrewMethod == "Partial Mash")
table(b$BrewMethod, b$BrewMethod_AllGrain)
table(b$BrewMethod, b$BrewMethod_BIAB)
table(b$BrewMethod, b$BrewMethod_Extract)
table(b$BrewMethod, b$BrewMethod_PartialMash)


# drop all character fields for modeling
# can get descriptors back by joining to earlier dataset on BeerID
library(dplyr)
bm <- b %>%
    select(
        BeerID,
        OG,
        FG,
        ABV,
        IBU,
        Color,
        BoilSize,
        BoilTime,
        BoilGravity,
        Efficiency,
        MashThickness,
        SugarScale_Plato,
        SugarScale_SpecificGravity,
        BrewMethod_AllGrain,
        BrewMethod_BIAB,
        BrewMethod_Extract,
        BrewMethod_PartialMash,
        PitchRate,
        PrimaryTemp,
        FlagIPA
    )


# we need to randomly split our dataset into 2 sets:
# 1 for building our model and 1 for validating it
# what we need is a uniform random number
# create a function for this so everyone in the class has the same sets
# (this has to do with setting the seed and how R works)
foo <- function(num, seed = 20190717) {
    set.seed(seed)
    runif(n = num)
}
head(foo(nrow(bm)))
# put random number on data set
bm$RandomNumber <- foo(nrow(bm))
# for skeptics, check a basic histogram
hist(bm$RandomNumber)


# now, we have about 74K observerations
mean(bm$FlagIPA)
# and a 23% success rate of our DV
# we could probably get by modeling on ~20% of our data but lets use 30%
bm$BuildValidate <- ifelse(
    bm$RandomNumber <= 0.30,
    "Build",
    "Validate"
)
summary(factor(bm$BuildValidate))


# save dataset in RData file
save(list = c("bm"), file = "_03_CreateModelingDataset.RData")
