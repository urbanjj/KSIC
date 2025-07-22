#' 하위 KSIC 코드 추출 / Extract Child KSIC Codes
#'
#' @description
#' 입력된 KSIC 코드에 해당하는 하위 분류 코드를 추출합니다. 여러 자릿수의 코드가 혼합된 벡터를 입력할 수 있습니다.
#'
#' Extracts the child classification codes corresponding to the input KSIC codes. It can handle a vector containing codes with different numbers of digits.
#'
#' @param ksic character. 하위 코드를 찾을 KSIC 코드 벡터.
#'   A vector of KSIC codes to find child codes for.
#' @param digit integer. 추출하고자 하는 하위 분류의 자릿수 (1-5). 기본값은 5입니다.
#'   The digit of the child classification to extract (1-5). Default is 5.
#' @param C integer. KSIC 차수 (9, 10, 11). 기본값은 `getOption("ksic.C", 11)`입니다.
#'   The KSIC revision (9, 10, or 11). If NULL, `getOption("ksic.C", 11)` is used.
#' @param name logical. `TRUE`일 경우 코드명, `FALSE`일 경우 코드를 반환합니다. 기본값은 `FALSE`입니다.
#'   If `TRUE`, returns names; if `FALSE`, returns codes. Default is `FALSE`.
#' @return 각 입력 코드에 해당하는 하위 분류 코드 또는 이름의 벡터를 담은 리스트를 반환합니다. 하위 코드가 없으면 `NA`를 포함하는 리스트 요소가 반환됩니다.
#'   A list containing vectors of child codes or names for each input code. Returns a list element with `NA` if no child codes are found.
#' @export
#' @examples
#' # 여러 KSIC 코드의 4자리 하위 코드 조회
#' ksic_sub(c("26", "96", "52636"), digit = 4)
#'
#' # "58" 코드의 5자리 하위 코드명 조회
#' ksic_sub("58", digit = 5, name = TRUE)
ksic_sub <- function(ksic, digit = 5, C = NULL, name = FALSE) {
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

  # 자릿수별로 그룹화 / Group by digit
  ksic_nchars <- nchar(ksic)
  ksic_groups <- split(ksic, ksic_nchars)

  # 각 그룹별로 하위 코드 추출 / Extract child codes for each group
  result_groups_list <- lapply(names(ksic_groups), function(p_k_str) {
    p_k <- as.integer(p_k_str)
    sub_ksic <- ksic_groups[[p_k_str]]

    from_col <- paste0("ksic", p_k, "_cd")
    to_cd_col <- paste0("ksic", p_d, "_cd")
    to_nm_col <- paste0("ksic", p_d, "_nm")

    # merge를 위한 매핑 테이블 생성 / Create a mapping table for merging
    mapping_table <- unique(tree_subset[, c(from_col, to_cd_col, to_nm_col)])
    
    input_df <- data.frame(sub_ksic)
    names(input_df) <- from_col
    
    # merge를 사용하여 조인 / Join using merge
    merged_df <- merge(input_df, mapping_table, by = from_col, all.x = TRUE, sort = FALSE)

    # 결과를 입력 코드별로 리스트로 묶음 / Group results into a list by input code
    split(if (name) merged_df[[to_nm_col]] else merged_df[[to_cd_col]], merged_df[[from_col]])
  })

  # 결과를 하나의 리스트로 통합 / Combine the results into a single list
  final_result_map <- do.call(c, result_groups_list)
  
  # 원래 ksic 벡터의 순서대로 결과를 반환 / Return the results in the order of the original ksic vector
  return(final_result_map[ksic])
}