# load clean beer RData
load("_04_PerformModelEDA.RData")


# load packages needed
library(dplyr)


# limit to build subset (important)
x <- bmx %>%
    filter(BuildValidate == "Build")


# build model using glm function (stats package) with "binomial" family
help(glm)
# build model object
xm <- glm(
    formula = FlagIPA ~ IBU + ABV + Color + PrimaryTemp + OG,
    data = x,
    family = "binomial"
)
summary(xm)
# discuss this output


# save model object in RData file
save(list = c("xm"), file = "_05_BuildLogisticModel.RData")
