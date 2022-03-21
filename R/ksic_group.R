#' grouping ksic code
#' @export
ksic_group <- function(ksic, digit=1, C=10, name = F){
  p_k <- unique(nchar(ksic))
  p_d <- as.numeric(digit)
  p_C <- as.numeric(C)
  if(!p_d %in% c(1:5)){
    stop("digit이 잘못 입력되었습니다.")
  } else if(!p_C %in% c(9,10)){
    stop("차수가 잘못 입력되었습니다.")
  } else if(length(p_k) != 1){
    stop(paste0("ksic의 digit이 서로 다릅니다."))
  } else if(p_k < p_d){
    stop("ksic의 digit이 digit 보다 작습니다.")
  } else if(sum(ksic %in% ksicDB[ksicDB$ksic_C==paste0("C",p_C),]$cd) != length(ksic)){
    stop(paste0("ksic가 ",C,"차에 없습니다."))
  } else{
    z <- ksicTreeDB[ksicTreeDB$ksic_C==paste0("C",p_C),]
    z <- data.frame(z[,paste0("ksic",p_k,"_cd")],
                    z[,paste0("ksic",digit,"_cd")],
                    z[,paste0("ksic",digit,"_nm")])
    z <- dplyr::distinct(z)
    names(z) <- c('j','cd','nm')
    z <- dplyr::left_join(data.frame(j=ksic), z, by = "j")
    if(sum(z$j == ksic) != length(ksic)){
      stop("return값의 order가 ksic와 맞지 않습니다.")
    }else if(name == T){
      z <- z$nm
    }else{
      z <- z$cd
    }
    return(z)
  }
}
