#' Search KSIC by Keyword
#'
#' @description
#' Searches for KSIC codes by a keyword in Korean or English classification names.
#' If searching with a Korean keyword, the English name (`eng_nm`) column is excluded from the result.
#'
#' @param keyword character. keyword to search for.
#' @param C integer. The KSIC revision. If NULL, `getOption("ksic.C", 11)` is used.
#' @param ignore.case logical. If `TRUE`, the case is ignored during search. Default is `TRUE`.
#' @param digit integer. Can be a vector of (1-5). If NULL, all digits are searched.
#'
#' @return A data.frame of matching KSIC codes and names, or `NULL` if no match is found.
#' @export
#' @examples
#'
#' ksic_search("software", C = 10, ignore.case = FALSE, digit = 5)
#'
#' ksic_search("data|database")
ksic_search <- function(keyword, C = NULL, ignore.case = TRUE, digit = NULL) {
  # Input validation
  if (is.null(C)) {
    p_C <- getOption("ksic.C", 11)
  } else {
    p_C <- as.integer(C)
  }

  if (!p_C %in% c(9, 10, 11)) {
    stop("Value of 'C' must be numeric of 9, 10, or 11.")
  }
  if (!is.null(digit) && !all(as.integer(digit) %in% 1:5)) {
    stop("Value of 'digit' must be numeric(s) between 1 and 5.")
  }

  # Filter data for the corresponding revision
  db_subset <- ksicDB[ksicDB$ksic_C == paste0("C", p_C), ]

  # Filter by digit
  if (!is.null(digit)) {
    db_subset <- db_subset[db_subset$digit %in% as.integer(digit), ]
  }

  # Keyword search
  # Check if the keyword contains Korean characters
  contains_korean <- grepl("[\uAC00-\uD7A3]", keyword)

  # Search English names only if eng_nm exists, is not NA, and the keyword is not Korean
  eng_match <- if (!contains_korean && "eng_nm" %in% names(db_subset) && any(!is.na(db_subset$eng_nm))) {
    grepl(keyword, db_subset$eng_nm, ignore.case = ignore.case)
  } else {
    FALSE
  }

  # Search in the nm column
  kor_match <- grepl(keyword, db_subset$nm, ignore.case = ignore.case)

  # Combine the two search results
  result_df <- db_subset[kor_match | eng_match, ]

  if (nrow(result_df) == 0) {
    message("No matching results found.")
    return(invisible(NULL))
  }

  # Exclude English name column when searching with a Korean keyword
  if (contains_korean) {
    result_df$eng_nm <- NULL
  }

  return(result_df)
}
