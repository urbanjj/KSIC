#' 하위 KSIC 코드 추출 / Extract Child KSIC Codes
#'
#' @description
#' 입력된 KSIC 코드에 해당하는 하위 분류 코드를 추출합니다. 여러 자릿수의 코드가 혼합된 벡터를 입력할 수 있습니다.
#' Extracts the child classification codes corresponding to the input KSIC codes. It can handle a vector containing codes with different numbers of digits.
#'
#' @param ksic character. KSIC 코드 벡터. A vector of KSIC codes.
#' @param digit integer. 추출하고자 하는 하위 분류의 자릿수 (1-5). The digit of the child classification to extract (1-5). Default is 5.
#' @param C integer. KSIC 차수 (9 또는 10). The KSIC revision (9 or 10). Default is 10.
#' @param name logical. TRUE일 경우 코드명, FALSE일 경우 코드를 반환. If TRUE, returns names; if FALSE, returns codes. Default is FALSE.
#' @return list. 각 입력 코드에 해당하는 하위 분류 코드 또는 코드명의 벡터를 담은 리스트. A list containing vectors of child codes or names for each input code.
#' @export
ksic_sub <- function(ksic, digit = 5, C = 10, name = FALSE) {
  # 입력 값 유효성 검사
  p_d <- as.integer(digit)
  p_C <- as.integer(C)
  if (!p_d %in% 1:5) stop("digit은 1, 2, 3, 4, 5 중 하나여야 합니다.")
  if (!p_C %in% c(9, 10)) stop("C(차수)는 9 또는 10이어야 합니다.")
  if (!is.character(ksic)) stop("ksic은 문자형 벡터여야 합니다.")
  if (any(nchar(ksic) >= p_d)) stop("입력된 ksic 코드의 자릿수가 목표 자릿수(digit)보다 크거나 같을 수 없습니다.")

  # 차수에 맞는 데이터만 사전 필터링
  ksic_c_str <- paste0("C", p_C)
  tree_subset <- ksicTreeDB[ksicTreeDB$ksic_C == ksic_c_str, ]

  # 자릿수별로 그룹화
  ksic_nchars <- nchar(ksic)
  ksic_groups <- split(ksic, ksic_nchars)

  # 각 그룹별로 하위 코드 추출
  result_groups_list <- lapply(names(ksic_groups), function(p_k_str) {
    p_k <- as.integer(p_k_str)
    sub_ksic <- ksic_groups[[p_k_str]]

    from_col <- paste0("ksic", p_k, "_cd")
    to_cd_col <- paste0("ksic", p_d, "_cd")
    to_nm_col <- paste0("ksic", p_d, "_nm")

    # merge를 위한 매핑 테이블 생성
    mapping_table <- unique(tree_subset[, c(from_col, to_cd_col, to_nm_col)])
    
    input_df <- data.frame(sub_ksic)
    names(input_df) <- from_col
    
    # merge를 사용하여 조인
    merged_df <- merge(input_df, mapping_table, by = from_col, all.x = TRUE, sort = FALSE)

    # 결과를 입력 코드별로 리스트로 묶음
    split(if (name) merged_df[[to_nm_col]] else merged_df[[to_cd_col]], merged_df[[from_col]])
  })

  # 결과를 하나의 리스트로 통합
  final_result_map <- do.call(c, result_groups_list)
  
  # 원래 ksic 벡터의 순서대로 결과를 반환
  return(final_result_map[ksic])
}