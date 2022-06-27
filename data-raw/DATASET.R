## code to prepare datas goes here
load("data-raw/brainMeans.RData")
imputeMissingBrainCpGs <- brainMeans
usethis::use_data(imputeMissingBrainCpGs, overwrite = TRUE)

load("data-raw/PCBrainAge.RData")
PCBrainAge_Model <- PCBrainAge
usethis::use_data(PCBrainAge_Model, overwrite = TRUE)
