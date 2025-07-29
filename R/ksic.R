#' Get KSIC Data
#'
#' @description
#' Returns a data.frame of KSIC data for the specified revision and digit.
#'
#' @param digit integer. The digit of the classification to extract (1-5). Default is 5.
#' @param C integer. The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param eng_nm logical. If `TRUE`, includes English classification names; if `FALSE`, excludes them. Default is `FALSE`.
#' @return A data.frame containing the specified KSIC codes and names.
#' @export
#' @examples
#' ksic(digit = 1)
#'
#' ksic(digit = 2, C = 10, eng_nm = TRUE)
ksic <- function(digit = 5, C = NULL, eng_nm = FALSE) {
  p_d <- as.integer(digit)
  
  if (is.null(C)) {
    p_C <- getOption("ksic.C", 11)
  } else {
    p_C <- as.integer(C)
  }

  if (!p_d %in% 1:5) {
    stop("Invalid 'digit' parameter. Must be an integer between 1 and 5.")
  }
  if (!p_C %in% c(9, 10, 11)) {
    stop("Invalid 'C' parameter. Must be 9, 10, or 11.")
  }

  # Filter data
  result <- ksicDB[(ksicDB$ksic_C == paste0("C", p_C)) & (ksicDB$digit == p_d), ]
    
    # Exclude English name column based on eng_nm parameter
    if (!eng_nm) {
      result$eng_nm <- NULL
    }
    
    return(result)
}
