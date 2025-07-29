#' Extract Child KSIC Codes
#'
#' @description
#' Extracts the child classification codes corresponding to the input KSIC codes. It can handle a vector containing codes with different numbers of digits.
#'
#' @param ksic character.
#'   A vector of KSIC codes to find child codes for.
#' @param digit integer.
#'   The digit of the child classification to extract (1-5). Default is 5.
#' @param C integer.
#'   The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param name logical.
#'   If `TRUE`, returns names; if `FALSE`, returns codes. Default is `FALSE`.
#' @return A list containing vectors of child codes or names for each input code. Returns a list element with `NA` if no child codes are found.
#' @export
#' @examples
#' ksic_sub(c("26", "96", "52636"), digit = 4)
#'
#' ksic_sub("58", digit = 5, name = TRUE)
ksic_sub <- function(ksic, digit = 5, C = NULL, name = FALSE) {
  # Input validation
  p_d <- as.integer(digit)
  
  if (is.null(C)) {
    p_C <- getOption("ksic.C", 11)
  } else {
    p_C <- as.integer(C)
  }

  if (!is.character(ksic)) {
    stop("Invalid 'ksic' parameter. Must be a character vector.")
  }
  if (!p_d %in% 1:5) {
    stop("Invalid 'digit' parameter. Must be an integer between 1 and 5.")
  }
  if (!p_C %in% c(9, 10, 11)) {
    stop("Invalid 'C' parameter. Must be 9, 10, or 11.")
  }

  # Create a result list that preserves the original order and names
  final_result_map <- vector("list", length(ksic))
  names(final_result_map) <- ksic
  
  # Validate KSIC codes
  is_valid <- is_ksic(ksic)[paste0('C',p_C)][,1]
  
  # Warn for any invalid codes
  if (any(!is_valid)) {
    message(paste("Invalid KSIC codes detected and will be returned as NA:", 
                  paste(unique(ksic[!is_valid]), collapse = ", ")))
    # Set invalid entries to NA
    final_result_map[!is_valid] <- NA
  }
  
  # Filter to process only the valid codes, avoiding redundant processing
  valid_ksic_codes <- unique(ksic[is_valid])

  if (length(valid_ksic_codes) > 0) {
    # Pre-filter data for the corresponding revision
    ksic_c_str <- paste0("C", p_C)
    tree_subset <- ksicTreeDB[ksicTreeDB$ksic_C == ksic_c_str, ]

    # Group by digit
    ksic_nchars <- nchar(valid_ksic_codes)
    ksic_groups <- split(valid_ksic_codes, ksic_nchars)

    # Extract child codes for each group
    result_groups_list <- lapply(names(ksic_groups), function(p_k_str) {
      p_k <- as.integer(p_k_str)
      sub_ksic <- ksic_groups[[p_k_str]]

      from_col <- paste0("ksic", p_k, "_cd")
      to_cd_col <- paste0("ksic", p_d, "_cd")
      to_nm_col <- paste0("ksic", p_d, "_nm")

      # If the requested digit is smaller than the input code's digit, return an empty list
      if (p_d < p_k) {
        return(sapply(sub_ksic, function(x) NA, USE.NAMES = TRUE))
      }

      # Create a mapping table for merging
      mapping_table <- unique(tree_subset[, c(from_col, to_cd_col, to_nm_col)])
      
      input_df <- data.frame(sub_ksic)
      names(input_df) <- from_col
      
      # Join using merge
      merged_df <- merge(input_df, mapping_table, by = from_col, all.x = TRUE, sort = FALSE)

      # Group results into a list by input code
      split(if (name) merged_df[[to_nm_col]] else merged_df[[to_cd_col]], merged_df[[from_col]])
    })

    # Combine the processed results into a single named list
    processed_results <- do.call(c, result_groups_list)
    
    # Place the valid results into our final map
    final_result_map[names(processed_results)] <- processed_results
  }
  
  # Return the results in the order of the original ksic vector
  return(final_result_map)
}