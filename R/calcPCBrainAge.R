#' calcPCBrainAge
#'
#' @description A function to calculate the predictor of PCBrainAge
#'
#' @param DNAm a matrix of methylation beta values. Needs to be rows = samples and columns = CpGs, with (ideally) rownames and (required) colnames.
#' @param pheno Optional: The sample phenotype data (also with samples as rows) that the clock will be appended to.
#' @param CpGImputation An optional named vector for the mean value of each CpG that will be input from another dataset if such values are missing here. If no vector is provided, will use data("imputeMissingBrainCpGs") for mean imputation. See data description for more details.
#'
#' @return If you added the optional pheno input (preferred) the function appends a column with the PCBrainAge calculation and returns the dataframe. Otherwise, it will return a vector of calculated clock values in order of input samples.
#' @export
#'
#' @examples calcPCBrainAge(exampleBetas, examplePheno)
calcPCBrainAge <- function(DNAm, pheno = NULL, CpGImputation = NULL){

  #######################
  ### Read in the Data###
  #######################

  # data("PCBrainAge_Model")
  # data("rotation1")
  # data("rotation2")
  # data("rotation3")
  # data("centering1")
  # data("centering2")
  # data("modelFit")

  PCBrainAge_Model <- list()
  PCBrainAge_Model$rotation <- rbind(rotation1, rotation2, rotation3)
  PCBrainAge_Model$center <- c(centering1, centering2)
  PCBrainAge_Model$coefs <- modelFit$coefs
  PCBrainAge_Model$intercept <- modelFit$intercept

  # rm("modelFit","rotation1","rotation2","rotation3","centering1","centering2")

  ###################################################
  ### Check if all necessary CpGs are in the data ###
  ###################################################
  missingCpGs <- rownames(PCBrainAge_Model$rotation)[!(rownames(PCBrainAge_Model$rotation) %in% colnames(DNAm))]
  DNAm[,missingCpGs] <- NA
  if(!is.na(missingCpGs[1])){           #if there are columns of CpGs missing...
    if(is.null(CpGImputation)){         #...and the user didn't specify a mean CpG vector, use the Hannum 2013 blood mean data
      data("imputeMissingBrainCpGs")
      for(i in 1:length(missingCpGs)){
        datMeth[,missingCpGs[i]] <- imputeMissingBrainCpGs[missingCpGs[i]]
      }} else{                          #...otherwise use the user's mean CpG vector which contains the required CpG values
        for(i in 1:length(missingCpGs)){
          datMeth[,missingCpGs[i]] <- CpGImputation[missingCpGs[i]]
        }
      }
    }

  message("Any missing CpGs successfully filled in (see function for more details)")

  DNAm <- DNAm[,match(rownames(PCBrainAge_Model$rotation), colnames(DNAm))]

  if(any(is.na(DNAm))){
    DNAm <- apply(DNAm,2,meanimpute)
    message("Mean imputation successfully completed for missing CpG values")
  }

  ###################################################################################
  ### The calculation will be performed or an error will be thrown as appropriate ###
  ###################################################################################

  PCBrainAge_prediction <-  as.numeric(sweep(as.matrix(DNAm),2,PCBrainAge_Model$center,"-") %*% PCBrainAge_Model$rotation %*% PCBrainAge_Model$coef + PCBrainAge_Model$intercept)

  message("PCBrainAge Successfully calculated!")

  if(is.null(pheno)){
    PCBrainAge_prediction
  } else{
    pheno$PCBrainAge <- PCBrainAge_prediction
    pheno
  }
}










