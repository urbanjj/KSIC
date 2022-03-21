#' subsetting ksic sub code
#' @export
ksic_sub <- function(ksic, digit=5, C=10, name=F){
  p_k <- unique(nchar(ksic))
  p_d <- as.numeric(digit)
  p_C <- as.numeric(C)
  if(!p_d %in% c(1:5)){
    stop("Value of 'digit' must be numeric of 1,2,3,4 and 5.")
  } else if(!p_C %in% c(9,10)){
    stop("Value of 'C' must be numeric of 9 and 10.")
  } else if(length(p_k) != 1){
    stop(paste0("digit of 'ksic' must be unique."))
  }else if(sum(unique(nchar(ksic)) >= p_d) != 0){
    stop("ksic의 digit이 digit과 같거나 더 큽니다.")
  } else if(sum(ksic %in% ksicDB[ksicDB$ksic_C==paste0("C",p_C),]$cd) != length(ksic)){
    stop(paste0("ksic가 ",C,"차에 없습니다."))
  } else{
    z <- ksicTreeDB[ksicTreeDB$ksic_C==paste0("C",p_C),]
    z <- data.frame(z[,paste0("ksic",p_k,"_cd")],
                    z[,paste0("ksic",digit,"_cd")],
                    z[,paste0("ksic",digit,"_nm")])
    names(z) <- c('j','cd','nm')
    x <- lapply(ksic, function(x) z[z$j == x,]) |>
      dplyr::bind_rows()
    if(name == T){
      x <- x$nm
    } else{
      x <- x$cd
    }
    return(x)
  }
}
