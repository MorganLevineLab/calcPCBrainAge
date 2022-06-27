#' meanImpute
#'
#' @param x A vector which may contain NA values
#'
#' @return A vector where the NA entries have been replaced by the vector's mean
#' @export
#'
#' @examples imputedBetas <- apply(exampleBetas, 2, meanImpute)
meanImpute <- function(x) {
  ifelse(is.na(x),mean(x,na.rm=T),x)
}