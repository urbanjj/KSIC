#' KSIC 데이터 조회 / Get KSIC Data
#'
#' @description
#' 지정된 차수와 자릿수에 해당하는 KSIC 데이터를 데이터프레임 형태로 반환합니다.
#' Returns a data.frame of KSIC data for the specified revision and digit.
#'
#' @param digit integer. 추출하고자 하는 분류의 자릿수 (1-5). The digit of the classification to extract (1-5). Default is 5.
#' @param C integer. KSIC 차수 (9 또는 10). The KSIC revision (9 or 10). Default is 10.
#' @return A data.frame containing the specified KSIC codes and names.
#' @export
ksic <- function(digit = 5, C = 10) {
  p_d <- as.integer(digit)
  p_C <- as.integer(C)
  if (!p_d %in% 1:5) {
    stop("Value of 'digit' must be numeric of 1,2,3,4 and 5.")
  } else if (!p_C %in% c(9, 10)) {
    stop("Value of 'C' must be numeric of 9 and 10.")
  } else {
    # 불필요한 data.frame() 호출 제거 및 paste0 사용
    ksicDB[(ksicDB$ksic_C == paste0("C", p_C)) & (ksicDB$digit == p_d), ]
  }
}
