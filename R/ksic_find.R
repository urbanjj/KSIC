#' Find KSIC Information by Code
#'
#' @description
#' Searches for KS.IC information by code.
#'
#' @param codes character. A vector of KSIC codes.
#'
#' @return A data.frame of matching KSIC codes and names.
#' @export
#'
ksic_find <- function(codes) {
  if (!is.character(codes)) {
    stop("Value of 'codes' must be character.")
  }
  
  validity <- is_ksic(codes)
  
  valid_codes <- codes[rowSums(validity[, c("C9", "C10", "C11")]) > 0]
  invalid_codes <- codes[rowSums(validity[, c("C9", "C10", "C11")]) == 0]
  
  if (length(invalid_codes) > 0) {
    message("Invalid codes excluded from search: ", paste(invalid_codes, collapse = ", "))
  }
  
  if (length(valid_codes) == 0) {
    message("No valid codes to search.")
    return(invisible(NULL))
  }
  
  result <- ksicDB[ksicDB$cd %in% valid_codes, ]
  result <- result[order(match(result$cd, valid_codes)), ]
  
  return(result)
}
