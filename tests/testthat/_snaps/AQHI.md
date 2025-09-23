# AQHI returns expected output

    Code
      aqhi_en
    Output
      # A tibble: 24 x 15
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>                      <int>      <int>       <int>         <dbl>
       1 2024-01-01 00:00:00             1          1           1            NA
       2 2024-01-01 01:00:00             2          2           2            NA
       3 2024-01-01 02:00:00             3          3           3             2
       4 2024-01-01 03:00:00             4          4           4             3
       5 2024-01-01 04:00:00             5          5           5             4
       6 2024-01-01 05:00:00             6          6           6             5
       7 2024-01-01 06:00:00             7          7           7             6
       8 2024-01-01 07:00:00             8          8           8             7
       9 2024-01-01 08:00:00             9          9           9             8
      10 2024-01-01 09:00:00            10         10          10             9
      # i 14 more rows
      # i 10 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>, colour <chr>,
      #   risk <fct>, high_risk_pop_message <chr>, general_pop_message <chr>

---

    Code
      aqhi_fr
    Output
      # A tibble: 24 x 15
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>                      <int>      <int>       <int>         <dbl>
       1 2024-01-01 00:00:00             1          1           1            NA
       2 2024-01-01 01:00:00             2          2           2            NA
       3 2024-01-01 02:00:00             3          3           3             2
       4 2024-01-01 03:00:00             4          4           4             3
       5 2024-01-01 04:00:00             5          5           5             4
       6 2024-01-01 05:00:00             6          6           6             5
       7 2024-01-01 06:00:00             7          7           7             6
       8 2024-01-01 07:00:00             8          8           8             7
       9 2024-01-01 08:00:00             9          9           9             8
      10 2024-01-01 09:00:00            10         10          10             9
      # i 14 more rows
      # i 10 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>, colour <chr>,
      #   risk <fct>, high_risk_pop_message <chr>, general_pop_message <chr>

---

    Code
      aqhi_en_no_override
    Output
      # A tibble: 24 x 15
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>                      <int>      <int>       <int>         <dbl>
       1 2024-01-01 00:00:00             1          1           1            NA
       2 2024-01-01 01:00:00             2          2           2            NA
       3 2024-01-01 02:00:00             3          3           3             2
       4 2024-01-01 03:00:00             4          4           4             3
       5 2024-01-01 04:00:00             5          5           5             4
       6 2024-01-01 05:00:00             6          6           6             5
       7 2024-01-01 06:00:00             7          7           7             6
       8 2024-01-01 07:00:00             8          8           8             7
       9 2024-01-01 08:00:00             9          9           9             8
      10 2024-01-01 09:00:00            10         10          10             9
      # i 14 more rows
      # i 10 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>, colour <chr>,
      #   risk <fct>, high_risk_pop_message <chr>, general_pop_message <chr>

---

    Code
      aqhi_plus_en
    Output
      # A tibble: 24 x 15
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>                      <int>      <dbl>       <dbl>         <dbl>
       1 2024-01-01 00:00:00             1         NA          NA            NA
       2 2024-01-01 01:00:00             2         NA          NA            NA
       3 2024-01-01 02:00:00             3         NA          NA            NA
       4 2024-01-01 03:00:00             4         NA          NA            NA
       5 2024-01-01 04:00:00             5         NA          NA            NA
       6 2024-01-01 05:00:00             6         NA          NA            NA
       7 2024-01-01 06:00:00             7         NA          NA            NA
       8 2024-01-01 07:00:00             8         NA          NA            NA
       9 2024-01-01 08:00:00             9         NA          NA            NA
      10 2024-01-01 09:00:00            10         NA          NA            NA
      # i 14 more rows
      # i 10 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>, colour <chr>,
      #   risk <fct>, high_risk_pop_message <chr>, general_pop_message <chr>

---

    Code
      aqhi_plus_fr
    Output
      # A tibble: 24 x 15
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>                      <int>      <dbl>       <dbl>         <dbl>
       1 2024-01-01 00:00:00             1         NA          NA            NA
       2 2024-01-01 01:00:00             2         NA          NA            NA
       3 2024-01-01 02:00:00             3         NA          NA            NA
       4 2024-01-01 03:00:00             4         NA          NA            NA
       5 2024-01-01 04:00:00             5         NA          NA            NA
       6 2024-01-01 05:00:00             6         NA          NA            NA
       7 2024-01-01 06:00:00             7         NA          NA            NA
       8 2024-01-01 07:00:00             8         NA          NA            NA
       9 2024-01-01 08:00:00             9         NA          NA            NA
      10 2024-01-01 09:00:00            10         NA          NA            NA
      # i 14 more rows
      # i 10 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>, colour <chr>,
      #   risk <fct>, high_risk_pop_message <chr>, general_pop_message <chr>

