#' KSIC 키워드 검색 / Search KSIC by Keyword
#'
#' @description
#' 국문 또는 영문 분류명에 포함된 키워드로 KSIC 코드를 검색합니다. 
#' 한글 키워드로 검색 시 결과에서 영문명(`eng_nm`) 열은 제외됩니다.
#' Searches for KSIC codes by a keyword in Korean or English classification names.
#' If searching with a Korean keyword, the English name (`eng_nm`) column is excluded from the result.
#'
#' @param keyword character. 검색할 키워드. A keyword to search for.
#' @param C integer. KSIC 차수 (9, 10, 11). The KSIC revision. If NULL, `getOption("ksic.C", 11)` is used.
#' @param ignore.case logical. 대소문자를 무시할지 여부. If `TRUE`, the case is ignored during search. Default is `TRUE`.
#' @param digit integer. 검색할 분류 자릿수 (1-5). Can be a vector. If NULL, all digits are searched.
#'
#' @return A data.frame of matching KSIC codes and names, or `NULL` if no match is found.
#' @export
#' @examples
#' # 11차 개정에서 "소프트웨어"가 포함된 모든 분류 검색
#' ksic_search("소프트웨어")
#'
#' # 10차 개정에서 "software"가 포함된 5자리 분류 검색 (대소문자 구분)
#' ksic_search("software", C = 10, ignore.case = FALSE, digit = 5)
#'
#' # "data" 또는 "database" 검색
#' ksic_search("data|database")
ksic_search <- function(keyword, C = NULL, ignore.case = TRUE, digit = NULL) {
  # 입력 값 유효성 검사 / Input validation
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

  # 차수에 맞는 데이터 필터링 / Filter data for the corresponding revision
  db_subset <- ksicDB[ksicDB$ksic_C == paste0("C", p_C), ]

  # 자릿수 필터링 / Filter by digit
  if (!is.null(digit)) {
    db_subset <- db_subset[db_subset$digit %in% as.integer(digit), ]
  }

  # 키워드 검색 / Keyword search
  # 한글 포함 여부 확인 / Check if the keyword contains Korean characters
  contains_korean <- grepl("[\uAC00-\uD7A3]", keyword)

  # eng_nm 열이 존재하고 NA가 아니며, 한글 검색어가 아닐 경우에만 영문 검색 / Search English names only if eng_nm exists, is not NA, and the keyword is not Korean
  eng_match <- if (!contains_korean && "eng_nm" %in% names(db_subset) && any(!is.na(db_subset$eng_nm))) {
    grepl(keyword, db_subset$eng_nm, ignore.case = ignore.case)
  } else {
    FALSE
  }

  # nm 열에서 검색 / Search in the nm column
  kor_match <- grepl(keyword, db_subset$nm, ignore.case = ignore.case)

  # 두 검색 결과를 합침 / Combine the two search results
  result_df <- db_subset[kor_match | eng_match, ]

  if (nrow(result_df) == 0) {
    message("No matching results found.")
    return(invisible(NULL))
  }

  # 한글 키워드 검색 시 영문명 컬럼 제외 / Exclude English name column when searching with a Korean keyword
  if (contains_korean) {
    result_df$eng_nm <- NULL
  }

  return(result_df)
}
