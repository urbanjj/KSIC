## setting
library(readxl)
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(data.table)
library(stringr)

unzip('./data-raw/9th.zip', exdir='./data-raw/')
unzip('./data-raw/10th.zip', exdir='./data-raw/')
unzip('./data-raw/11th.zip', exdir='./data-raw/')

##################### ksicTreeDB
col_nm <- c("ksic1_cd", "ksic1_nm", "ksic2_cd", "ksic2_nm", "ksic3_cd", "ksic3_nm", "ksic4_cd", "ksic4_nm", "ksic5_cd", "ksic5_nm")

## 11th
excel_sheets('./data-raw/11th/7.한국표준산업분류 제11차 개정 분류체계(대-중-소-세-세세 구분) _20240626043559.xlsx')
C0 <- read_excel('./data-raw/11th/7.한국표준산업분류 제11차 개정 분류체계(대-중-소-세-세세 구분) _20240626043559.xlsx',
                sheet='11차개정한국표준산업분류',skip=2, col_names=T, col_types='text')
setnames(C0, col_nm)
C1 <- filter(C0, !is.na(ksic5_cd)) %>%
  fill(all_of(col_nm),.direction = 'down') %>%
  mutate(ksic_C='C11')

sapply(C1, \(x) length(unique(x)))

## 10th
excel_sheets('./data-raw/10th/한국표준산업분류(10차)_표.xlsx')
B0 <- read_excel('./data-raw/10th/한국표준산업분류(10차)_표.xlsx',
                sheet='10차개정한국표준산업분류',skip=2, col_names=T, col_types='text')
setnames(B0, col_nm)
B1 <- filter(B0, !is.na(ksic5_cd)) %>%
  fill(all_of(col_nm),.direction = 'down') %>%
  mutate(ksic_C='C10')

sapply(B1, \(x) length(unique(x)))

## 9th
A0 <- read_csv('./data-raw/9th/KSIC2007_tree.csv') %>%
  select(all_of(col_nm))

A1 <- A0 %>%
  mutate(ksic_C = 'C9')

sapply(A1, \(x) length(unique(x)))

ksicTreeDB <- bind_rows(C1,B1,A1) %>% as.data.frame()
str(ksicTreeDB)

save(ksicTreeDB, file='./data/ksicTreeDB.rda', compress = "xz")

rm(list=ls())

load('./data/ksicTreeDB.rda')

##################### ksicDB
## 11th
C0 <- read_excel('./data-raw/11th/KSIC_11th.xlsx',col_names=F,col_types = 'text')
setnames(C0, c('cd','nm','eng_nm'))

C1 <- filter(C0, !is.na(cd))

c0 <- filter(C1, is.na(nm))$cd
c2 <- c0[seq(1, length(c0), by = 2)]
c3 <- c0[seq(2, length(c0), by = 2)]

C1.result <- tibble(nm=c2, eng_nm=c3) %>%
  mutate(cd=str_sub(nm,1,1)) %>%
  mutate(nm=str_sub(nm,3,str_length(nm))) %>%
  relocate(cd,nm,eng_nm)

C2 <- bind_rows(C1.result, filter(C1, !is.na(nm))) %>%
  mutate(digit=str_length(cd),ksic_C='C11')

as.data.table(C2)[,.N,by=.(digit)]

## 10th
B0 <- read_excel('./data-raw/10th/KSIC_10th.xlsx',col_names=F,col_types = 'text')
setnames(B0, c('cd','nm','eng_nm'))

B1 <- filter(B0, !is.na(cd))

b0 <- filter(B1, is.na(nm))$cd
b2 <- b0[seq(1, length(b0), by = 2)]
b3 <- b0[seq(2, length(b0), by = 2)]

B1.result <- tibble(nm=b2, eng_nm=b3) %>%
  mutate(cd=str_sub(nm,1,1)) %>%
  mutate(nm=str_sub(nm,3,str_length(nm))) %>%
  relocate(cd,nm,eng_nm)

B2 <- bind_rows(B1.result, filter(B1, !is.na(nm))) %>%
  mutate(digit=str_length(cd),ksic_C='C10')

as.data.table(B2)[,.N,by=.(digit)]

## 9th
excel_sheets('./data-raw/9th/KSIC2007.xls')
A0 <- read_excel('./data-raw/9th/KSIC2007.xls', col_names=F,
col_types='text')
setnames(A0, c('cd','nm','eng_nm'))

A1 <- filter(A0, !is.na(cd))

a0 <- filter(A1, is.na(nm))$cd
a2 <- sapply(a0, \(x) str_split(x, '\n')[[1]][1])
a3 <- sapply(a0, \(x) str_split(x, '\n')[[1]][2])

A1.result <- tibble(nm=a2, eng_nm=a3) %>%
  mutate(cd=str_sub(nm,1,1)) %>%
  mutate(nm=str_sub(nm,3,str_length(nm))) %>%
  relocate(cd,nm,eng_nm)

A2 <- bind_rows(A1.result, filter(A1, !is.na(nm))) %>%
  mutate(digit=str_length(cd),ksic_C='C9')

as.data.table(A2)[,.N,by=.(digit)]

ksicDB <- bind_rows(C2,B2,A2) %>% as.data.frame()
str(ksicDB)

save(ksicDB, file='./data/ksicDB.rda', compress = "xz")
rm(list=ls())

load('./data/ksicDB.rda')

##################### ksic_9_to_10 & ksic_10_to_9
excel_sheets('./data-raw/10th/KSIC연계표(9차_10차).xlsx')

Q0 <- read_excel('./data-raw/10th/KSIC연계표(9차_10차).xlsx',
                sheet='10_9연계',skip=2, col_names=T, col_types='text')

setnames(Q0, c("ksic10_cd", "ksic10_nm", "ksic9_cd", "ksic9_nm", "con", "detail"))

ksic_10_to_9 <- mutate_all(Q0, ~str_trim(.x, side='both')) %>%
  mutate_all(~ifelse(.x == '', NA, .x)) %>%
  tidyr::fill(ksic10_cd, ksic10_nm, .direction='down') %>%
  group_by(ksic10_cd) %>%
  tidyr::fill(detail, .direction='down') %>%
  as.data.frame()

Q1 <- read_excel('./data-raw/10th/KSIC연계표(9차_10차).xlsx',
                sheet='9_10연계',skip=2, col_names=T, col_types='text')

setnames(Q1, c("ksic9_cd", "ksic9_nm", "ksic10_cd", "ksic10_nm", "con", "detail"))

ksic_9_to_10 <- mutate_all(Q1, ~str_trim(.x, side='both')) %>%
  mutate_all(~ifelse(.x == '', NA, .x)) %>%
  tidyr::fill(ksic9_cd, ksic9_nm, .direction='down') %>%
  group_by(ksic10_cd) %>%
  tidyr::fill(detail, .direction='down') %>%
  as.data.frame()


save(ksic_10_to_9, file='./data/ksic_10_to_9.rda', compress = "xz")
save(ksic_9_to_10, file='./data/ksic_9_to_10.rda', compress = "xz")


##################### ksic_10_to_11 & ksic_11_to_10
excel_sheets('./data-raw/11th/4.한국표준산업분류 제11차-제10차 연계표_20240626043559.xlsx')

D0 <- read_excel('./data-raw/11th/4.한국표준산업분류 제11차-제10차 연계표_20240626043559.xlsx',
                sheet='신구연계표',skip=1, col_names=T, col_types='text')

setnames(D0, c('ksic11_cd', 'ksic11_nm', 'ksic10_cd', 'ksic10_nm', 'detail'))

ksic_11_to_10 <- D0 %>%
  as.data.frame()

D1 <- read_excel('./data-raw/11th/4.한국표준산업분류 제11차-제10차 연계표_20240626043559.xlsx',
                sheet='구신연계표',skip=1, col_names=T, col_types='text')

setnames(D1, c('ksic10_cd', 'ksic10_nm', 'ksic11_cd', 'ksic11_nm', 'detail'))

ksic_10_to_11 <- D1 %>%
  as.data.frame()

save(ksic_11_to_10, file='./data/ksic_11_to_10.rda', compress = "xz")
save(ksic_10_to_11, file='./data/ksic_10_to_11.rda', compress = "xz")


## data-raw
file.copy('./data/ksicDB.rda','./data-raw/ksicDB.rda', overwrite = TRUE)
file.copy('./data/ksicTreeDB.rda','./data-raw/ksicTreeDB.rda', overwrite = TRUE)
file.copy('./data/ksic_9_to_10.rda','./data-raw/ksic_9_to_10.rda', overwrite = TRUE)
file.copy('./data/ksic_10_to_9.rda','./data-raw/ksic_10_to_9.rda', overwrite = TRUE)
file.copy('./data/ksic_10_to_11.rda','./data-raw/ksic_10_to_11.rda', overwrite = TRUE)
file.copy('./data/ksic_11_to_10.rda','./data-raw/ksic_11_to_10.rda', overwrite = TRUE)


save(ksic_9_to_10, ksic_10_to_9, ksic_10_to_11, ksic_11_to_10, file = "R/sysdata.rda", compress = "xz")

unlink('./data-raw/9th',recursive = TRUE)
unlink('./data-raw/10th',recursive = TRUE)
unlink('./data-raw/11th',recursive = TRUE)
