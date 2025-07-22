#' 한국표준산업분류 데이터 / Korea Standard Industry Code Data
#'
#' @description
#' 9차 및 10차 한국표준산업분류(KSIC)의 코드, 이름, 차수, 자릿수 정보를 포함하는 데이터셋입니다.
#' A dataset containing the codes, names, revisions, and digits of the 9th and 10th Korea Standard Industrial Classification (KSIC).
#'
#' @source \url{https://kssc.kostat.go.kr}
#' @format A data frame with columns:
#' \describe{
#' \item{cd}{분류 코드. Classification code.}
#' \item{nm}{분류명. Classification name.}
#' \item{eng_nm}{영문 분류명. English classification name.}
#' \item{digit}{분류 자릿수 (1-5). Digit of the classification (1-5).}
#' \item{ksic_C}{KSIC 차수 (C9 또는 C10). KSIC revision (C9 or C10).}
#' }
#' @examples
#'   ksicDB
"ksicDB"

