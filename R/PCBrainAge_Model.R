#' @title The Model for predicting PCBrainAge
#'
#' @description The object required to perform predictions of PCBrainAge
#'
#' @format A list object of model components
#' \describe{
#'   \item{rotation}{A matrix containing the right singular vectors necessary to predict the PCs of PCBrainAge in new data. Note that rownames(PCBrainAge_Model$rotation) will give you a list of CpGs needed for the model}
#'   \item{center}{The centering values required for properly centering the Beta values across samples prior to projection on the rotation matrix.}
#'   \item{coefs}{The coefficient weights of the PCs in the PCBrainAge model.}
#'   \item{intercept}{The intercept of the PCBrainAge regression model.}
#'   }
#'
#' @source <https://doi.org/10.1101/2022.02.28.481849>
"PCBrainAge_Model"
