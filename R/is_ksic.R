#' Check for Valid KSIC Codes
#'
#' @description
#' Checks if the input codes are valid for the given KSIC revision (9th, 10th, or 11th).
#'
#' @param ksic character. A vector of KSIC codes to check.
#' @return A data.frame with the input codes and logical columns (C9, C10, C11) indicating validity.
#' @export
is_ksic <- function(ksic){
  if (!is.character(ksic)) {
    stop("Value of 'ksic' must be character.")
  }
  
  # Use the main ksicDB for validation
  C11_valid <- ksic %in% ksicDB$cd[ksicDB$ksic_C == "C11"]
  C10_valid <- ksic %in% ksicDB$cd[ksicDB$ksic_C == "C10"]
  C9_valid  <- ksic %in% ksicDB$cd[ksicDB$ksic_C == "C9"]
  
  data.frame(input = ksic,
             C11 = C11_valid,
             C10 = C10_valid,
             C9 = C9_valid)
}
