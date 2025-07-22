#' KSIC 코드 유효성 검사 / Check for Valid KSIC Codes
#'
#' @description
#' 입력된 코드가 주어진 KSIC 차수(9차, 10차, 11차)에 유효한 코드인지 확인합니다.
#' Checks if the input codes are valid for the given KSIC revision (9th, 10th, or 11th).
#'
#' @param ksic character. 확인할 KSIC 코드 벡터. A vector of KSIC codes to check.
#' @return A data.frame with the input codes and logical columns (C9, C10, C11) indicating validity.
#' @export
is_ksic <- function(ksic){
  if (!is.character(ksic)) {
    stop("Value of 'ksic' must be character.")
  }
  # 미리 생성된 내부 데이터를 사용하여 성능 향상 / Use pre-generated internal data for performance
  data.frame(input = ksic,
             C11 = ksic %in% ksicDB_C11_codes,
             C10 = ksic %in% ksicDB_C10_codes,
             C9 = ksic %in% ksicDB_C9_codes)
}
