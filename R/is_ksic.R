#' is ksic?
#' @export
is_ksic <- function(ksic){
  if(is.character(ksic) == F){
    stop("Value of 'ksic' must be character.")
  }  else{
    return(data.frame(input = ksic,
                      C10 = ksic %in% ksicDB[ksicDB$ksic_C=="C10",]$ksic_cd,
                      C9 = ksic %in% ksicDB[ksicDB$ksic_C=="C9",]$ksic_cd))
  }
}
