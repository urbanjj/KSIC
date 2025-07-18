#' 한국표준산업분류 트리 구조 데이터 / Korea Standard Industry Code Tree Data
#'
#' @description
#' 9차 및 10차 KSIC의 계층 구조를 나타내는 데이터셋입니다. 각 세세분류(5-digit)에 대한 상위 분류 코드가 포함되어 있습니다.
#' A dataset representing the hierarchical structure of the 9th and 10th KSIC. It includes parent codes for each 5-digit classification.
#'
#' @source \url{https://kssc.kostat.go.kr}
#' @format A data frame with columns for each classification level (1 to 5 digits) and the KSIC revision.
#' @examples
#'   ksicTreeDB
"ksicTreeDB"
