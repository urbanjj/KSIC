#' print ksic
#' @export
ksic <- function(digit=5, C=10){
  p_d <- as.integer(digit)
  p_C <- as.integer(C)
  if(!p_d %in% c(1:5)){
    stop("Value of 'digit' must be numeric of 1,2,3,4 and 5.")
  } else if(!p_C %in% c(9,10)){
    stop("Value of 'C' must be numeric of 9 and 10.")
  } else{
    return(data.frame(ksicDB[(ksicDB$ksic_C == paste("C",C,sep=""))&(ksicDB$digit == digit),]))
  }
}
