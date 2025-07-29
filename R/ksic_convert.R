#' Convert KSIC Codes
#'
#' @description
#' Converts KSIC codes from one revision to another.
#'
#' @param ksic character. A vector of 5-digit KSIC codes to convert (e.g., '10111').
#' @param from_C integer. The source KSIC revision (9, 10, or 11).
#' @param to_C integer. The target KSIC revision (9, 10, or 11).
#' @return data.frame. A data.frame containing converted KSIC codes and related information. Only convertible codes from the input will be included.
#' @export
#' @examples
#' ksic_convert(c("27192", "27195"), from_C = 10, to_C = 11)
#'
#' ksic_convert(c("27192", "27195"), from_C = 11, to_C = 10)
ksic_convert <- function(ksic, from_C, to_C) {
  # Input validation
  if (!is.character(ksic)) {
    stop("Invalid 'ksic' parameter. Must be a character vector.")
  }
  if (!all(nchar(ksic) == 5)) {
    stop("Invalid 'ksic' parameter. All codes must be 5-digit strings.")
  }
  if (!from_C %in% c(9, 10, 11)) {
    stop("Invalid 'from_C' parameter. Must be 9, 10, or 11.")
  }
  if (!to_C %in% c(9, 10, 11)) {
    stop("Invalid 'to_C' parameter. Must be 9, 10, or 11.")
  }
  if (from_C == to_C) {
    message("Source and target KSIC revisions are the same. Returning original codes.")
    return(ksic)
  }

  # Construct the data frame name dynamically
  data_name <- paste0("ksic_", from_C, "_to_", to_C)

  # Access internal data using get()
  # This is a more robust way to access package data
  if (!exists(data_name, envir = as.environment("package:KSIC"))) {
      message(paste0("Conversion data '", data_name, "' not found. This conversion path may not be supported."))
      return(invisible(NULL))
  }
  
  conversion_df <- get(data_name, envir = as.environment("package:KSIC"))

  # Define column names based on from_C and to_C
  from_col_name <- paste0("ksic", from_C, "_cd")
  to_col_name <- paste0("ksic", to_C, "_cd")

  # Perform the conversion
  # Use match to find the corresponding 'to' codes
  converted_df <- conversion_df[conversion_df[[from_col_name]] %in% ksic, ]

  if (nrow(converted_df) == 0) {
    message("No convertible codes found.")
    return(invisible(NULL))
  }

  return(converted_df)
}
