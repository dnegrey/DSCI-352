# load clean beer RData and model object
load("_04_PerformModelEDA.RData")
load("_05_BuildLogisticModel.RData")


# load packages needed
library(miscTools)


# use model object to "score" full dataset (build and validate subsets)
x <- bmx
x$ScoreIPA <- predict(
    object = xm,
    newdata = x,
    type = "response"
)


# create a model performance object using miscTools
help("modelPerformance")
xp <- modelPerformance(
    y = x$FlagIPA,
    yhat = x$ScoreIPA,
    v = x$BuildValidate == "Validate"
)


# create a model performance report using miscTools
help("modelPerformance_Report")
modelPerformance_Report(
    x = xp,
    projectLabel = "Logistic IPA Model Performance"
)
