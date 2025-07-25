
<!-- README.md is generated from README.Rmd. Please edit that file -->

# KSIC(Korea Standard Industrial Classification) 한국표준산업분류

This package provides tools to utilize the Korea Standard Industrial
Classification (KSIC) in R.

R에서 한국표준산업분류(KSIC)를 이용하기 위한 패키지입니다.

- Data: **ksicDB**, **ksicTreeDB**, **ksic_9_to_10**, **ksic_10_to_9**,
  **ksic_10_to_11**, **ksic_11_to_10**
- Function: **ksic()**, **is_ksic()**, **ksic_group()**, **ksic_sub()**,
  **ksic_convert()**, **ksic_search()**

The data is sourced from: 데이터의 출처는 아래와 같습니다.

- \[Korea Statistical Classification Portal (통계분류포털)\]

## Installation

You can install the KSIC package from GitHub with: KSIC package는 아래와
같이 설치할 수 있습니다.

``` r
# install.packages("devtools")
devtools::install_github("urbanjj/KSIC")
```

------------------------------------------------------------------------

## Data

This package includes several built-in datasets to support the functions.

이 패키지에는 함수를 지원하기 위한 여러 내장 데이터셋이 포함되어 있습니다.

This table shows the number of categories in each KSIC revision

KSIC 개정별 각 분류의 개수를 나타낸 표입니다.

| revision | Section(Alphabet) | Division (2 digit) | Group (3 digit) | Class (4 digit) | Sub-Class (5 digit) |
|:---|:---|:---|:---|:---|:---|
| 11th | 21 | 77 | 234 | 501 | 1,205 |
| 10th | 21 | 77 | 232 | 495 | 1,196 |
| 9th | 21 | 76 | 228 | 487 | 1,145 |

- `ksicDB`: A comprehensive data frame containing all codes, names
  (Korean and English), digits, and revision numbers for the 9th, 10th,
  and 11th KSIC.

- `ksicDB`: 9차, 10차, 11차 KSIC의 모든 코드, 이름(국문, 영문), 자릿수,
  차수 정보를 포함하는 데이터프레임입니다.

- `ksicTreeDB`: A data frame representing the hierarchical structure of
  the KSIC, mapping each 5-digit code to its parent codes at all levels
  (1 to 4 digits).

- `ksicTreeDB`: 각 5자리 코드를 모든 상위 수준(1~4자리)의 상위 코드에
  매핑하여 KSIC의 계층 구조를 나타내는 데이터프레임입니다.

- `ksic_9_to_10`, `ksic_10_to_9`, `ksic_10_to_11`, `ksic_11_to_10`:
  Concordance tables for converting codes between different KSIC
  revisions.

- `ksic_9_to_10`, `ksic_10_to_9`, `ksic_10_to_11`, `ksic_11_to_10`: 서로
  다른 KSIC 개정 간에 코드를 변환하기 위한 연계표입니다.

------------------------------------------------------------------------

## Global Option for KSIC Revision / 전역 옵션 설정

You can set a global default for the KSIC revision (the `C` parameter)
using R’s `options()` function. This avoids having to specify the
revision in every function call if you are consistently working with one
version. The default is 11.

R의 `options()` 함수를 사용하여 KSIC 차수(`C` 매개변수)에 대한 전역
기본값을 설정할 수 있습니다. 이렇게 하면 특정 버전으로 계속 작업하는
경우 모든 함수 호출에서 차수를 지정할 필요가 없습니다. 기본값은
11입니다.

**Example / 사용 예시:**

``` r
library(KSIC)
# Set the default KSIC revision to the 10th
# 기본 KSIC 차수를 10차로 설정
options(ksic.C = 10)

# Now, ksic() and other functions will use C = 10 by default
# 이제 ksic() 및 다른 함수들은 기본적으로 C = 10을 사용합니다.
head(ksic(digit = 1))
```

    ##      cd                                              nm digit ksic_C
    ## 2039  A                       농업, 임업 및 어업(01~03)     1    C10
    ## 2040  B                                     광업(05~08)     1    C10
    ## 2041  C                                   제조업(10~34)     1    C10
    ## 2042  D         전기, 가스, 증기 및 공기조절 공급업(35)     1    C10
    ## 2043  E 수도, 하수 및 폐기물 처리, 원료 재생업(36 ~ 39)     1    C10
    ## 2044  F                                   건설업(41~42)     1    C10

``` r
# Reset to the default (11th revision)
# 기본값(11차)으로 재설정
options(ksic.C = 11)
```

------------------------------------------------------------------------

## Core Functions / 주요 함수

This package offers four main functions designed for efficiency and
flexibility.

이 패키지는 효율성과 유연성을 고려하여 설계된 네 가지 주요 함수를 제공합니다.

### `ksic()`

Retrieves a `data.frame` of KSIC data filtered by a specific revision
and digit level. The default revision is 11.

특정 차수와 자릿수 수준으로 필터링된 KSIC 데이터프레임을 가져옵니다. 기본 차수는 11차입니다.

**Example / 사용 예시:**

``` r
# Get 1-digit codes from the default 11th revision
head(ksic(digit = 1))
```

    ##   cd                                              nm digit ksic_C
    ## 1  A                       농업, 임업 및 어업(01~03)     1    C11
    ## 2  B                                     광업(05~08)     1    C11
    ## 3  C                                   제조업(10~34)     1    C11
    ## 4  D         전기, 가스, 증기 및 공기조절 공급업(35)     1    C11
    ## 5  E 수도, 하수 및 폐기물 처리, 원료 재생업(36 ~ 39)     1    C11
    ## 6  F                                   건설업(41~42)     1    C11

``` r
# Get 1-digit codes including English names
head(ksic(digit = 1, eng_nm = TRUE))
```

    ##   cd                                              nm
    ## 1  A                       농업, 임업 및 어업(01~03)
    ## 2  B                                     광업(05~08)
    ## 3  C                                   제조업(10~34)
    ## 4  D         전기, 가스, 증기 및 공기조절 공급업(35)
    ## 5  E 수도, 하수 및 폐기물 처리, 원료 재생업(36 ~ 39)
    ## 6  F                                   건설업(41~42)
    ##                                                       eng_nm digit ksic_C
    ## 1                          Agriculture, forestry and fishing     1    C11
    ## 2                                       Mining and quarrying     1    C11
    ## 3                                              Manufacturing     1    C11
    ## 4        Electricity, gas, steam and air conditioning supply     1    C11
    ## 5 Water supply; sewage, waste management, materials recovery     1    C11
    ## 6                                               Construction     1    C11

### `is_ksic()`

Checks whether input codes are valid KSIC codes for the 9th, 10th, and
11th revisions.

입력된 코드가 9차, 10차, 11차 KSIC에서 유효한 코드인지 확인합니다.

**Example / 사용 예시:**

``` r
is_ksic(c("A", "01", "99999", "invalid_code"))
```

    ##          input   C11   C10    C9
    ## 1            A  TRUE  TRUE  TRUE
    ## 2           01  TRUE  TRUE  TRUE
    ## 3        99999 FALSE FALSE FALSE
    ## 4 invalid_code FALSE FALSE FALSE

### `ksic_group()`

Extracts the parent (upper-level) classification codes or names for a
vector of KSIC codes. The default revision is 11.

주어진 KSIC 코드 벡터에 대한 상위 분류 코드 또는 이름을 추출합니다. 기본 차수는 11차입니다.

**Key Features & Advantages / 주요 특징 및 장점:**
- **Flexible Input**: Handles vectors with mixed-digit codes (e.g., `c("011", "2622")`).
- **유연한 입력**: 자릿수가 다른 코드들이 섞인 벡터(예: `c("011", "2622")`)도 처리할 수 있습니다.
- **Efficient**: Uses an optimized `split-lapply-unsplit` pattern for fast lookups.
- **효율성**: 최적화된 `split-lapply-unsplit` 패턴을 사용하여 빠른 조회를 보장합니다.

**Example / 사용 예시:**

``` r
ksic_group(c("31311", "4631", "25", "A"), digit = 2, name = TRUE)
```

    ## [1] "기타 운송장비 제조업"                   
    ## [2] "도매 및 상품 중개업"                    
    ## [3] "금속 가공제품 제조업; 기계 및 가구 제외"
    ## [4] NA

### `ksic_sub()`

Extracts all child (lower-level) classification codes or names for a
vector of KSIC codes. The default revision is 11.

주어진 KSIC 코드 벡터에 대한 모든 하위 분류 코드 또는 이름을 추출합니다. 기본 차수는 11차입니다.

**Key Features & Advantages / 주요 특징 및 장점:**
- **Comprehensive Output**: Returns a `list` where each element contains a vector of child codes.
- **포괄적인 출력**: 각 입력 코드에 해당하는 하위 코드 벡터를 담은 `리스트`를 반환합니다.
- **Flexible Input**: Handles vectors with mixed-digit codes.
- **유연한 입력**: 자릿수가 다른 코드가 섞인 벡터도 처리합니다.

**Example / 사용 예시:**

``` r
result_list <- ksic_sub(c("26","96","52636"), digit = 4)
print(result_list)
```

    ## $`26`
    ##  [1] "2632" "2641" "2642" "2631" "2612" "2621" "2622" "2651" "2611" "2652"
    ## [11] "2660" "2629"
    ## 
    ## $`96`
    ## [1] "9611" "9612" "9691" "9692" "9699"
    ## 
    ## $`52636`
    ## [1] NA

### `ksic_convert()`

Converts KSIC codes from one revision to another.

주어진 KSIC 코드를 한 차수에서 다른 차수로 변환합니다.

> **Important Note** When converting between revisions, industry
> classifications may be merged, subdivided, or otherwise modified. This
> means a single code in one revision might map to multiple codes in
> another (1:N), or multiple codes might merge into one (N:1).
> `ksic_convert` returns a data frame reflecting these complex
> relationships. Users should carefully examine the results, especially
> when a one-to-one match is not guaranteed.
>
> **(중요) 차수 개정 시, 산업 분류는 통합, 분할 또는 변경될 수 있습니다.
> 즉, 특정 코드가 다른 차수에서 여러 코드로 나뉘거나(1:N), 여러 코드가
> 하나의 코드로 통합(N:1)될 수 있습니다. `ksic_convert` 함수는 이러한
> 복잡한 관계를 그대로 보여주는 데이터프레임을 반환하므로, 사용자는 변환
> 결과가 1:1이 아님을 주의하여야 합니다.**

**Example / 사용 예시:**

``` r
# Convert 10th revision codes to 11th revision
ksic_convert(c("27192", "27195"), from_C = 10, to_C = 11)
```

    ##     ksic10_cd                              ksic10_nm ksic11_cd
    ## 387     27192 정형 외과용 및 신체 보정용 기기 제조업     27192
    ## 388     27192 정형 외과용 및 신체 보정용 기기 제조업     27193
    ## 389     27192 정형 외과용 및 신체 보정용 기기 제조업     27194
    ##                                  ksic11_nm detail
    ## 387                      치과기공물 제조업   세분
    ## 388                 치과용 임플란트 제조업   세분
    ## 389 정형 외과용 및 신체 보정용 기기 제조업   세분

``` r
# Convert 11th revision codes to 10th revision
ksic_convert(c("27192", "27195"), from_C = 11, to_C = 10)
```

    ##     ksic11_cd               ksic11_nm ksic10_cd
    ## 387     27192       치과기공물 제조업     27192
    ## 390     27195 안경 및 안경렌즈 제조업     27193
    ##                                  ksic10_nm   detail
    ## 387 정형 외과용 및 신체 보정용 기기 제조업     세분
    ## 390                안경 및 안경렌즈 제조업 코드변경

### `ksic_search()`

Searches for KSIC codes by a keyword in Korean or English classification
names.

국문 또는 영문 분류명에 포함된 키워드로 KSIC 코드를 검색합니다.

**Example / 사용 예시:**

``` r
# Search for classifications containing "소프트웨어" in the 11th revision
ksic_search("소프트웨어")
```

    ##         cd                                                nm digit ksic_C
    ## 1120  4651             컴퓨터 및 주변장치, 소프트웨어 도매업     4    C11
    ## 1121 46510             컴퓨터 및 주변장치, 소프트웨어 도매업     5    C11
    ## 1205  4731 컴퓨터 및 주변장치, 소프트웨어 및 통신기기 소매업     4    C11
    ## 1206 47311             컴퓨터 및 주변장치, 소프트웨어 소매업     5    C11
    ## 1436   582                         소프트웨어 개발 및 공급업     3    C11
    ## 1437  5821                    게임 소프트웨어 개발 및 공급업     4    C11
    ## 1438 58211        유선 온라인 게임 소프트웨어 개발 및 공급업     5    C11
    ## 1439 58212             모바일 게임 소프트웨어 개발 및 공급업     5    C11
    ## 1440 58219               기타 게임 소프트웨어 개발 및 공급업     5    C11
    ## 1441  5822            시스템ㆍ응용 소프트웨어 개발 및 공급업     4    C11
    ## 1442 58221                  시스템 소프트웨어 개발 및 공급업     5    C11
    ## 1443 58222                    응용 소프트웨어 개발 및 공급업     5    C11

``` r
# Search for 5-digit classifications containing "software" in the 10th revision (case-sensitive)
ksic_search("software", C = 10, ignore.case = FALSE, digit = 5)
```

    ##         cd                                         nm
    ## 3155 46510      컴퓨터 및 주변장치, 소프트웨어 도매업
    ## 3238 47311      컴퓨터 및 주변장치, 소프트웨어 소매업
    ## 3467 58211 유선 온라인 게임 소프트웨어 개발 및 공급업
    ## 3468 58212      모바일 게임 소프트웨어 개발 및 공급업
    ## 3469 58219        기타 게임 소프트웨어 개발 및 공급업
    ## 3471 58221           시스템 소프트웨어 개발 및 공급업
    ## 3472 58222             응용 소프트웨어 개발 및 공급업
    ##                                                                    eng_nm digit
    ## 3155   Wholesale of computers, computer peripheral equipment and software     5
    ## 3238 Retail sale of computers, computer peripheral equipment and software     5
    ## 3467                                      Online game software publishing     5
    ## 3468                                      Mobile game software publishing     5
    ## 3469                                       Other game software publishing     5
    ## 3471                                           System software publishing     5
    ## 3472                                      Application software publishing     5
    ##      ksic_C
    ## 3155    C10
    ## 3238    C10
    ## 3467    C10
    ## 3468    C10
    ## 3469    C10
    ## 3471    C10
    ## 3472    C10

------------------------------------------------------------------------

## Practical Application / 활용 사례

### Enriching a Dataset with `ksic_group`

You can easily use `ksic_group` to enrich your dataset by adding parent
classifications.

`ksic_group`을 사용해 상위 분류 정보를 추가하여 데이터셋을 쉽게 확장할 수 있습니다.

``` r
my_data <- data.frame(
  company = c("A", "B", "C", "D"),
  ksic5_cd = c("26222", "58221", "26299", "61220")
)

my_data$ksic2_nm <- ksic_group(my_data$ksic5_cd, digit = 2, name = TRUE)
print(my_data)
```

    ##   company ksic5_cd                                         ksic2_nm
    ## 1       A    26222 전자 부품, 컴퓨터, 영상, 음향 및 통신장비 제조업
    ## 2       B    58221                                           출판업
    ## 3       C    26299 전자 부품, 컴퓨터, 영상, 음향 및 통신장비 제조업
    ## 4       D    61220                                   우편 및 통신업

### Finding All Sub-Industries with `ksic_sub`

`ksic_sub` is useful for identifying all specific industries within a
broader category. The list output can be easily converted into a tidy
data frame for further analysis.

`ksic_sub`는 특정 상위 분류에 속하는 모든 세부 산업을 찾아낼 때 유용합니다. 리스트 형태의 출력 결과는 추가 분석을 위해 데이터프레임으로 쉽게 변환할 수 있습니다.

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
print(head(sub_categories_df_base))
```

    ##   ksic2_cd ksic5_cd                            ksic5_nm
    ## 1       58    58113                    일반 서적 출판업
    ## 2       58    58123              정기 광고간행물 발행업
    ## 3       58    58190                  기타 인쇄물 출판업
    ## 4       58    58121                         신문 발행업
    ## 5       58    58122           잡지 및 정기간행물 발행업
    ## 6       58    58219 기타 게임 소프트웨어 개발 및 공급업

``` r
# --- Tidyverse Approach ---
# A more concise approach using the tidyverse (tidyr, tibble)
# tidyverse(tidyr, tibble)를 사용한 방법 (더 간결함)
# if (!require(tidyr)) install.packages("tidyr") 
# if (!require(tibble)) install.packages("tibble")

# 1. Create a nested tibble where some columns are lists
# 1. 리스트를 열로 포함하는 중첩된 tibble 생성
nested_tibble <- tibble::tibble(
    ksic2_cd = names(sub_codes_list),
    ksic5_cd = sub_codes_list,
    ksic5_nm = sub_names_list
)
# Step 1: Nested tibble (before unnesting)"
print(nested_tibble)
```

    ## # A tibble: 2 × 3
    ##   ksic2_cd ksic5_cd     ksic5_nm    
    ##   <chr>    <named list> <named list>
    ## 1 58       <chr [12]>   <chr [12]>  
    ## 2 61       <chr [5]>    <chr [5]>

``` r
# 2. Use tidyr::unnest() to expand the list-columns into regular rows
# 2. tidyr::unnest()를 사용하여 리스트 열을 일반적인 행으로 펼침
unnested_df <- tidyr::unnest(nested_tibble, cols = c(ksic5_cd, ksic5_nm))
# Step 2: Unnested tibble (final result)"
print(head(unnested_df))
```

    ## # A tibble: 6 × 3
    ##   ksic2_cd ksic5_cd ksic5_nm                           
    ##   <chr>    <chr>    <chr>                              
    ## 1 58       58113    일반 서적 출판업                   
    ## 2 58       58123    정기 광고간행물 발행업             
    ## 3 58       58190    기타 인쇄물 출판업                 
    ## 4 58       58121    신문 발행업                        
    ## 5 58       58122    잡지 및 정기간행물 발행업          
    ## 6 58       58219    기타 게임 소프트웨어 개발 및 공급업
