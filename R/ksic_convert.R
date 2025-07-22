#' KSIC 코드 변환 / Convert KSIC Codes
#'
#' @description
#' 주어진 KSIC 코드를 한 차수에서 다른 차수로 변환합니다.
#' Converts KSIC codes from one revision to another.
#'
#' @param ksic character. 변환할 5자리 KSIC 코드 벡터 (예: '10111'). A vector of 5-digit KSIC codes to convert (e.g., '10111').
#' @param from_C integer. 변환을 시작할 KSIC 차수 (9, 10, 11). The source KSIC revision (9, 10, or 11).
#' @param to_C integer. 변환할 목표 KSIC 차수 (9, 10, 11). The target KSIC revision (9, 10, or 11).
#' @return data.frame. 변환된 KSIC 코드와 관련 정보를 포함하는 데이터프레임. 입력된 코드 중 변환 가능한 코드만 포함됩니다.
#'   A data.frame containing converted KSIC codes and related information. Only convertible codes from the input will be included.
#' @export
#' @examples
#' # 10차 KSIC 코드를 11차 KSIC 코드로 변환
#' ksic_convert(c("27192", "27195"), from_C = 10, to_C = 11)
#'
#' # 11차 KSIC 코드를 10차 KSIC 코드로 변환
#' ksic_convert(c("27192", "27195"), from_C = 11, to_C = 10)
ksic_convert <- function(ksic, from_C, to_C) {
  # 입력 값 유효성 검사 / Input validation
  if (!is.character(ksic)) {
    stop("Value of 'ksic' must be a character vector.")
  }
  if (!all(nchar(ksic) == 5)) {
    stop("All KSIC codes in 'ksic' must be 5-digit codes (e.g., '10111').")
  }
  if (!from_C %in% c(9, 10, 11)) {
    stop("Value of 'from_C' must be 9, 10, or 11.")
  }
  if (!to_C %in% c(9, 10, 11)) {
    stop("Value of 'to_C' must be 9, 10, or 11.")
  }
  if (from_C == to_C) {
    message("Source and target KSIC revisions are the same. Returning original codes.")
    return(ksic)
  }

  # 동적으로 데이터프레임 이름 생성 / Construct the data frame name dynamically
  data_name <- paste0("ksic_", from_C, "_to_", to_C)

  # get()을 사용하여 내부 데이터에 접근 / Access internal data using get()
  # 패키지 데이터에 접근하는 더 안정적인 방법 / This is a more robust way to access package data
  if (!exists(data_name, envir = as.environment("package:KSIC"))) {
      message(paste0("Conversion data '", data_name, "' not found. This conversion path may not be supported."))
      return(invisible(NULL))
  }
  
  conversion_df <- get(data_name, envir = as.environment("package:KSIC"))

  # from_C와 to_C에 따라 열 이름 정의 / Define column names based on from_C and to_C
  from_col_name <- paste0("ksic", from_C, "_cd")
  to_col_name <- paste0("ksic", to_C, "_cd")

  # 변환 수행 / Perform the conversion
  # match를 사용하여 해당 'to' 코드 찾기 / Use match to find the corresponding 'to' codes
  converted_df <- conversion_df[conversion_df[[from_col_name]] %in% ksic, ]

  if (nrow(converted_df) == 0) {
    message("No convertible codes found.")
    return(invisible(NULL))
  }

  return(converted_df)
}
