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

  if (!p_d %in% 1:5) stop("Value of 'digit' must be one of 1, 2, 3, 4, 5.")
  if (!p_C %in% c(9, 10, 11)) stop("Value of 'C' (revision) must be one of 9, 10, 11.")
  if (!is.character(ksic)) stop("Value of 'ksic' must be a character vector.")

  # Pre-filter data for the corresponding revision
  ksic_c_str <- paste0("C", p_C)
  tree_subset <- ksicTreeDB[ksicTreeDB$ksic_C == ksic_c_str, ]

  # Group by digit
  ksic_nchars <- nchar(ksic)
  ksic_groups <- split(ksic, ksic_nchars)

  # Extract child codes for each group
  result_groups_list <- lapply(names(ksic_groups), function(p_k_str) {
    p_k <- as.integer(p_k_str)
    sub_ksic <- ksic_groups[[p_k_str]]

    from_col <- paste0("ksic", p_k, "_cd")
    to_cd_col <- paste0("ksic", p_d, "_cd")
    to_nm_col <- paste0("ksic", p_d, "_nm")

    # Create a mapping table for merging
    mapping_table <- unique(tree_subset[, c(from_col, to_cd_col, to_nm_col)])
    
    input_df <- data.frame(sub_ksic)
    names(input_df) <- from_col
    
    # Join using merge
    merged_df <- merge(input_df, mapping_table, by = from_col, all.x = TRUE, sort = FALSE)

    # Group results into a list by input code
    split(if (name) merged_df[[to_nm_col]] else merged_df[[to_cd_col]], merged_df[[from_col]])
  })

  # Combine the results into a single list
  final_result_map <- do.call(c, result_groups_list)
  
  # Return the results in the order of the original ksic vector
  return(final_result_map[ksic])
}