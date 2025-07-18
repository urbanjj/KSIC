
<!-- README.md is generated from README.Rmd. Please edit that file -->

# KSIC

This package provides tools to utilize the Korea Standard Industrial
Classification (KSIC) in R.

R에서 한국표준산업분류(KSIC)를 이용하기 위한 패키지입니다.

- Data: **ksicDB**, **ksicTreeDB**, **ksic_9_to_10**, **ksic_10_to_9**
- Function: **ksic()**, **is_ksic()**, **ksic_group()**, **ksic_sub()**

The data is sourced from: 데이터의 출처는 아래와 같습니다.

- [Korea Statistical Classification Portal
  (통계분류포털)](https://kssc.kostat.go.kr)

## Installation

You can install the KSIC package from GitHub with: KSIC package는 아래와
같이 설치할 수 있습니다.

``` r
# install.packages("devtools")
devtools::install_github("jjyunnn/KSIC")
```

------------------------------------------------------------------------

## Core Functions / 주요 함수

This package offers four main functions designed for efficiency and
flexibility. 이 패키지는 효율성과 유연성을 고려하여 설계된 네 가지 주요
함수를 제공합니다.

### `ksic()`

Retrieves a `data.frame` of KSIC data filtered by a specific revision
and digit level. 특정 차수와 자릿수 수준으로 필터링된 KSIC
데이터프레임을 가져옵니다.

**Example / 사용 예시:**

``` r
library(KSIC)
ksic(digit = 1, C = 10)
#>      cd                                                               nm digit
#> 1958  A                                        농업, 임업 및 어업(01~03)     1
#> 1959  B                                                      광업(05~08)     1
#> 1960  C                                                    제조업(10~34)     1
#> 1961  D                         전기, 가스, 증기 및 공기 조절 공급업(35)     1
#> 1962  E                    수도, 하수 및 폐기물 처리, 원료 재생업(36~39)     1
#> 1963  F                                                    건설업(41~42)     1
#> 1964  G                                            도매 및 소매업(45~47)     1
#> 1965  H                                            운수 및 창고업(49~52)     1
#> 1966  I                                          숙박 및 음식점업(55~56)     1
#> 1967  J                                                정보통신업(58~63)     1
#> 1968  K                                            금융 및 보험업(64~66)     1
#> 1969  L                                                     부동산업(68)     1
#> 1970  M                               전문, 과학 및 기술 서비스업(70~73)     1
#> 1971  N                 사업시설 관리, 사업 지원 및 임대 서비스업(74~76)     1
#> 1972  O                             공공 행정, 국방 및 사회보장 행정(84)     1
#> 1973  P                                                교육 서비스업(85)     1
#> 1974  Q                               보건업 및 사회복지 서비스업(86~87)     1
#> 1975  R                         예술, 스포츠 및 여가관련 서비스업(90~91)     1
#> 1976  S                  협회 및 단체, 수리 및 기타 개인 서비스업(94~96)     1
#> 1977  T 가구 내 고용활동 및 달리 분류되지 않은 자가 소비 생산활동(97~98)     1
#> 1978  U                                             국제 및 외국기관(99)     1
#>      ksic_C
#> 1958    C10
#> 1959    C10
#> 1960    C10
#> 1961    C10
#> 1962    C10
#> 1963    C10
#> 1964    C10
#> 1965    C10
#> 1966    C10
#> 1967    C10
#> 1968    C10
#> 1969    C10
#> 1970    C10
#> 1971    C10
#> 1972    C10
#> 1973    C10
#> 1974    C10
#> 1975    C10
#> 1976    C10
#> 1977    C10
#> 1978    C10
```

### `is_ksic()`

Checks whether input codes are valid KSIC codes for the 9th and 10th
revisions. 입력된 코드가 9차 및 10차 KSIC에서 유효한 코드인지
확인합니다.

**Example / 사용 예시:**

``` r
is_ksic(c("A", "01", "99999", "invalid_code"))
#>          input   C10    C9
#> 1            A  TRUE  TRUE
#> 2           01  TRUE  TRUE
#> 3        99999 FALSE FALSE
#> 4 invalid_code FALSE FALSE
```

### `ksic_group()`

Extracts the parent (upper-level) classification codes or names for a
vector of KSIC codes. 주어진 KSIC 코드 벡터에 대한 상위 분류 코드 또는
이름을 추출합니다.

**Key Features & Advantages / 주요 특징 및 장점:** - **Flexible Input**:
Handles vectors with mixed-digit codes (e.g., `c("011", "2622")`). -
**유연한 입력**: 자릿수가 다른 코드들이 섞인 벡터(예:
`c("011", "2622")`)도 처리할 수 있습니다. - **Efficient**: Uses an
optimized `split-lapply-unsplit` pattern for fast lookups. - **효율성**:
최적화된 `split-lapply-unsplit` 패턴을 사용하여 빠른 조회를 보장합니다.

**Example / 사용 예시:**

``` r
ksic_group(c("31311", "4631", "25"), digit = 2, name = TRUE)
#> [1] "기타 운송장비 제조업"                   
#> [2] "도매 및 상품 중개업"                    
#> [3] "금속 가공제품 제조업; 기계 및 가구 제외"
```

### `ksic_sub()`

Extracts all child (lower-level) classification codes or names for a
vector of KSIC codes. 주어진 KSIC 코드 벡터에 대한 모든 하위 분류 코드
또는 이름을 추출합니다.

**Key Features & Advantages / 주요 특징 및 장점:** - **Comprehensive
Output**: Returns a `list` where each element contains a vector of child
codes. - **포괄적인 출력**: 각 입력 코드에 해당하는 하위 코드 벡터를
담은 `리스트`를 반환합니다. - **Flexible Input**: Handles vectors with
mixed-digit codes. - **유연한 입력**: 자릿수가 다른 코드가 섞인 벡터도
처리합니다.

**Example / 사용 예시:**

``` r
result_list <- ksic_sub(c("26","96"), digit = 4)
print(result_list)
#> $`26`
#>  [1] "2660" "2611" "2612" "2621" "2641" "2642" "2651" "2652" "2632" "2622"
#> [11] "2629" "2631"
#> 
#> $`96`
#> [1] "9611" "9612" "9691" "9692" "9699"
```

------------------------------------------------------------------------

## Practical Application / 활용 사례

### Enriching a Dataset with `ksic_group`

You can easily use `ksic_group` to enrich your dataset by adding parent
classifications. `ksic_group`을 사용해 상위 분류 정보를 추가하여
데이터셋을 쉽게 확장할 수 있습니다.

``` r
my_data <- data.frame(
  company = c("A", "B", "C", "D"),
  ksic5_cd = c("26222", "58221", "26299", "61220")
)

my_data$ksic2_nm <- ksic_group(my_data$ksic5_cd, digit = 2, name = TRUE)
print(my_data)
#>   company ksic5_cd                                         ksic2_nm
#> 1       A    26222 전자 부품, 컴퓨터, 영상, 음향 및 통신장비 제조업
#> 2       B    58221                                           출판업
#> 3       C    26299 전자 부품, 컴퓨터, 영상, 음향 및 통신장비 제조업
#> 4       D    61220                                   우편 및 통신업
```

### Finding All Sub-Industries with `ksic_sub`

`ksic_sub` is useful for identifying all specific industries within a
broader category. The list output can be easily converted into a tidy
data frame for further analysis. `ksic_sub`는 특정 상위 분류에 속하는
모든 세부 산업을 찾아낼 때 유용합니다. 리스트 형태의 출력 결과는 추가
분석을 위해 데이터프레임으로 쉽게 변환할 수 있습니다.

``` r
# 분석할 중분류 코드 정의
# Define mid-level divisions for analysis
target_divisions <- c("58", "61") # 출판업, 우편 및 통신업

# ksic_sub를 사용하여 세세분류(5-digit) 코드와 코드명 찾기
# Use ksic_sub to find all 5-digit sub-category codes and names
sub_codes_list <- ksic_sub(target_divisions, digit = 5, name = FALSE)
sub_names_list <- ksic_sub(target_divisions, digit = 5, name = TRUE)

# --- Base R Approach ---
# Base R을 사용하여 리스트를 데이터프레임으로 변환
# Convert the list to a data.frame using Base R
sub_categories_df_base <- data.frame(
  ksic2_cd = rep(names(sub_codes_list), lengths(sub_codes_list)),
  ksic5_cd = unlist(sub_codes_list, use.names = FALSE),
  ksic5_nm = unlist(sub_names_list, use.names = FALSE)
)
cat("--- Using Base R ---\n")
#> --- Using Base R ---
print(head(sub_categories_df_base))
#>   ksic2_cd ksic5_cd                   ksic5_nm
#> 1       58    58112                만화 출판업
#> 2       58    58113           일반 서적 출판업
#> 3       58    58121                신문 발행업
#> 4       58    58111 교과서 및 학습 서적 출판업
#> 5       58    58123    정기 광고 간행물 발행업
#> 6       58    58190         기타 인쇄물 출판업

# --- Tidyverse Approach ---
# A more concise approach using the tidyverse (tidyr, tibble)
# tidyverse(tidyr, tibble)를 사용한 방법 (더 간결함)
# if (!require(tidyr)) install.packages("tidyr") 
# if (!require(tibble)) install.packages("tibble")

cat("\n--- Using Tidyverse ---\n")
#> 
#> --- Using Tidyverse ---

# 1. Create a nested tibble where some columns are lists
# 1. 리스트를 열로 포함하는 중첩된 tibble 생성
nested_tibble <- tibble::tibble(
    ksic2_cd = names(sub_codes_list),
    ksic5_cd = sub_codes_list,
    ksic5_nm = sub_names_list
)
cat("\nStep 1: Nested tibble (before unnesting)\n")
#> 
#> Step 1: Nested tibble (before unnesting)
print(nested_tibble)
#> # A tibble: 2 × 3
#>   ksic2_cd ksic5_cd     ksic5_nm    
#>   <chr>    <named list> <named list>
#> 1 58       <chr [12]>   <chr [12]>  
#> 2 61       <chr [5]>    <chr [5]>

# 2. Use tidyr::unnest() to expand the list-columns into regular rows
# 2. tidyr::unnest()를 사용하여 리스트 열을 일반적인 행으로 펼침
unnested_df <- tidyr::unnest(nested_tibble, cols = c(ksic5_cd, ksic5_nm))
cat("\nStep 2: Unnested tibble (final result)\n")
#> 
#> Step 2: Unnested tibble (final result)
print(head(unnested_df))
#> # A tibble: 6 × 3
#>   ksic2_cd ksic5_cd ksic5_nm                  
#>   <chr>    <chr>    <chr>                     
#> 1 58       58112    만화 출판업               
#> 2 58       58113    일반 서적 출판업          
#> 3 58       58121    신문 발행업               
#> 4 58       58111    교과서 및 학습 서적 출판업
#> 5 58       58123    정기 광고 간행물 발행업   
#> 6 58       58190    기타 인쇄물 출판업
```
