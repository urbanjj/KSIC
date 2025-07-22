#' KSIC 데이터 조회 / Get KSIC Data
#'
#' @description
#' 지정된 차수와 자릿수에 해당하는 KSIC 데이터를 데이터프레임 형태로 반환합니다.
#'
#' Returns a data.frame of KSIC data for the specified revision and digit.
#'
#' @param digit integer. 추출하고자 하는 분류의 자릿수 (1-5). 기본값은 5입니다.
#'   The digit of the classification to extract (1-5). Default is 5.
#' @param C integer. KSIC 차수 (9, 10, 11). 기본값은 `getOption("ksic.C", 11)`입니다.
#'   The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param eng_nm logical. `TRUE`일 경우 영문 분류명을 포함하고, `FALSE`일 경우 제외합니다. 기본값은 `FALSE`입니다.
#'   If `TRUE`, includes English classification names; if `FALSE`, excludes them. Default is `FALSE`.
#' @return 지정된 조건에 맞는 KSIC 코드와 이름이 포함된 데이터프레임을 반환합니다.
#'   A data.frame containing the specified KSIC codes and names.
#' @export
#' @examples
#' # 11차 KSIC의 1자리 코드 조회
#' ksic(digit = 1)
#'
#' # 10차 KSIC의 2자리 코드 및 영문명 조회
#' ksic(digit = 2, C = 10, eng_nm = TRUE)
ksic <- function(digit = 5, C = NULL, eng_nm = FALSE) {
  p_d <- as.integer(digit)
  
  if (is.null(C)) {
    p_C <- getOption("ksic.C", 11)
  } else {
    p_C <- as.integer(C)
  }

  if (!p_d %in% 1:5) {
    stop("Value of 'digit' must be numeric of 1,2,3,4 and 5.")
  } else if (!p_C %in% c(9, 10, 11)) {
    stop("Value of 'C' must be numeric of 9, 10, and 11.")
  } else {
    # 데이터 필터링 / Filter data
    result <- ksicDB[(ksicDB$ksic_C == paste0("C", p_C)) & (ksicDB$digit == p_d), ]
    
    # eng_nm 매개변수에 따라 영문명 컬럼 제외 / Exclude English name column based on eng_nm parameter
    if (!eng_nm) {
      result$eng_nm <- NULL
    }
    
    return(result)
  }
}
