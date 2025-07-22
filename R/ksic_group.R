#' 상위 KSIC 코드 추출 / Extract Parent KSIC Codes
#'
#' @description
#' 입력된 KSIC 코드에 해당하는 상위 분류 코드를 추출합니다. 여러 자릿수의 코드가 혼합된 벡터를 입력할 수 있습니다.
#'
#' Extracts the parent classification codes corresponding to the input KSIC codes. It can handle a vector containing codes with different numbers of digits.
#'
#' @param ksic character. 상위 코드를 찾을 KSIC 코드 벡터.
#'   A vector of KSIC codes to find parent codes for.
#' @param digit integer. 추출하고자 하는 상위 분류의 자릿수 (1-5). 기본값은 1입니다.
#'   The digit of the parent classification to extract (1-5). Default is 1.
#' @param C integer. KSIC 차수 (9, 10, 11). 기본값은 `getOption("ksic.C", 11)`입니다.
#'   The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param name logical. `TRUE`일 경우 코드명, `FALSE`일 경우 코드를 반환합니다. 기본값은 `FALSE`입니다.
#'   If `TRUE`, returns names; if `FALSE`, returns codes. Default is `FALSE`.
#' @return 입력 벡터와 동일한 길이의 문자형 벡터를 반환합니다. 각 요소는 해당 KSIC 코드의 상위 분류 코드 또는 이름입니다. 상위 코드가 없으면 `NA`가 반환됩니다.
#'   A character vector of the same length as the input vector, containing parent codes or names. Returns `NA` if a parent code does not exist.
#' @export
#' @examples
#' # 여러 KSIC 코드의 2자리 상위 코드명 조회
#' ksic_group(c("31311", "4631", "25", "A"), digit = 2, name = TRUE)
#'
#' # 5자리 코드의 4자리 상위 코드 조회
#' ksic_group("26222", digit = 4)
ksic_group <- function(ksic, digit = 1, C = NULL, name = FALSE) {
  # 입력 값 유효성 검사 / Input validation
  p_d <- as.integer(digit)
  
  if (is.null(C)) {
    p_C <- getOption("ksic.C", 11)
  } else {
    p_C <- as.integer(C)
  }

  if (!p_d %in% 1:5) stop("Value of 'digit' must be one of 1, 2, 3, 4, 5.")
  if (!p_C %in% c(9, 10, 11)) stop("Value of 'C' (revision) must be one of 9, 10, 11.")
  if (!is.character(ksic)) stop("Value of 'ksic' must be a character vector.")

  # 차수에 맞는 데이터만 사전 필터링 / Pre-filter data for the corresponding revision
  ksic_c_str <- paste0("C", p_C)
  tree_subset <- ksicTreeDB[ksicTreeDB$ksic_C == ksic_c_str, ]

  # 자릿수별로 그룹화하기 위한 팩터 생성 / Create a factor for grouping by digit
  ksic_nchars <- nchar(ksic)
  
  # split + lapply + unsplit 패턴 적용 / Apply split + lapply + unsplit pattern
  ksic_groups <- split(ksic, ksic_nchars)
  
  result_groups <- lapply(names(ksic_groups), function(p_k_str) {
    p_k <- as.integer(p_k_str)
    sub_ksic <- ksic_groups[[p_k_str]]
    
    # 요청된 자릿수보다 작은 자릿수의 코드는 NA 처리 / Process codes with fewer digits than requested as NA
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
  
  # 원래 순서대로 결과를 합침 / Combine results in the original order
  return(unsplit(result_groups, ksic_nchars))
}