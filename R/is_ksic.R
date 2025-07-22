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
  # Use pre-generated internal data for performance
  data.frame(input = ksic,
             C11 = ksic %in% ksicDB_C11_codes,
             C10 = ksic %in% ksicDB_C10_codes,
             C9 = ksic %in% ksicDB_C9_codes)
}
