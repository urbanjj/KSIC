#' Extract Parent KSIC Codes
#'
#' @description
#' Extracts the parent classification codes corresponding to the input KSIC codes. It can handle a vector containing codes with different numbers of digits.
#'
#' @param ksic character.
#'   A vector of KSIC codes to find parent codes for.
#' @param digit integer.
#'   The digit of the parent classification to extract (1-5). Default is 1.
#' @param C integer.
#'   The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param name logical.
#'   If `TRUE`, returns names; if `FALSE`, returns codes. Default is `FALSE`.
#' @return A character vector of the same length as the input vector, containing parent codes or names. Returns `NA` if a parent code does not exist.
#' @export
#' @examples
#' ksic_group(c("31311", "4631", "25", "A"), digit = 2, name = TRUE)
#'
#' ksic_group("26222", digit = 4)
ksic_group <- function(ksic, digit = 1, C = NULL, name = FALSE) {
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

  # Create a result vector that preserves the original order
  final_result_map <- rep(NA, length(ksic))
  
  # Validate KSIC codes
  is_valid <- is_ksic(ksic)[paste0('C',p_C)][,1]

  # Warn for any invalid codes
  if (any(!is_valid)) {
    message(paste("Invalid KSIC codes detected and will be returned as NA:", 
                  paste(unique(ksic[!is_valid]), collapse = ", ")))
  }

  # Filter to process only the valid codes
  valid_ksic_codes <- ksic[is_valid]

  if (length(valid_ksic_codes) > 0) {
    # Pre-filter data for the corresponding revision
    ksic_c_str <- paste0("C", p_C)
    tree_subset <- ksicTreeDB[ksicTreeDB$ksic_C == ksic_c_str, ]

    # Create a factor for grouping by digit
    ksic_nchars <- nchar(valid_ksic_codes)
    
    # Apply split + lapply + unsplit pattern
    ksic_groups <- split(valid_ksic_codes, ksic_nchars)
    
    result_groups <- lapply(names(ksic_groups), function(p_k_str) {
      p_k <- as.integer(p_k_str)
      sub_ksic <- ksic_groups[[p_k_str]]
      
      # Process codes with fewer digits than requested as NA
      if (p_k < p_d) {
        return(rep(NA, length(sub_ksic)))
      }

      from_col <- paste0("ksic", p_k, "_cd")
      to_cd_col <- paste0("ksic", p_d, "_cd")
      to_nm_col <- paste0("ksic", p_d, "_nm")
      
      mapping_table <- unique(tree_subset[, c(from_col, to_cd_col, to_nm_col)])
      names(mapping_table) <- c("j", "cd", "nm")
      
      match_indices <- match(sub_ksic, mapping_table$j)
      
      if (name) {
        return(mapping_table$nm[match_indices])
      } else {
        return(mapping_table$cd[match_indices])
      }
    })
    
    # Combine results for valid codes
    processed_results <- unsplit(result_groups, ksic_nchars)
    
    # Place the valid results into our final map
    final_result_map[is_valid] <- processed_results
  }
  
  # Return the final result vector
  return(final_result_map)
}