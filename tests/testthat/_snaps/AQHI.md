# AQHI returns expected output

    Code
      aqhi_en
    Output
      # A tibble: 8,571 x 18
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>              <units>       <units>    <units>             <dbl>
       1 2018-01-01 09:00:00   NA          0.7        18.1                 NA  
       2 2018-01-01 10:00:00 12.1           NA        17.5                 NA  
       3 2018-01-01 11:00:00 10.7          0.2          NA                 11.4
       4 2018-01-01 12:00:00   NA           NA          NA                 11.4
       5 2018-01-01 13:00:00   NA           NA        16.6                 NA  
       6 2018-01-01 14:00:00  6.6           NA          NA                 NA  
       7 2018-01-01 15:00:00   NA          1.9          NA                 NA  
       8 2018-01-01 16:00:00  6.1          0.3        16.9                  6.3
       9 2018-01-01 17:00:00  7.1          1.0        18.1                  6.6
      10 2018-01-01 18:00:00  7.9          2.5        16.9                  7  
      # i 8,561 more rows
      # i 13 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>,
      #   AQHI_pm25_ratio <dbl>, AQHI_o3_ratio <dbl>, AQHI_no2_ratio <dbl>,
      #   colour <chr>, risk <fct>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>

---

    Code
      aqhi_fr
    Output
      # A tibble: 8,571 x 18
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>              <units>       <units>    <units>             <dbl>
       1 2018-01-01 09:00:00   NA          0.7        18.1                 NA  
       2 2018-01-01 10:00:00 12.1           NA        17.5                 NA  
       3 2018-01-01 11:00:00 10.7          0.2          NA                 11.4
       4 2018-01-01 12:00:00   NA           NA          NA                 11.4
       5 2018-01-01 13:00:00   NA           NA        16.6                 NA  
       6 2018-01-01 14:00:00  6.6           NA          NA                 NA  
       7 2018-01-01 15:00:00   NA          1.9          NA                 NA  
       8 2018-01-01 16:00:00  6.1          0.3        16.9                  6.3
       9 2018-01-01 17:00:00  7.1          1.0        18.1                  6.6
      10 2018-01-01 18:00:00  7.9          2.5        16.9                  7  
      # i 8,561 more rows
      # i 13 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>,
      #   AQHI_pm25_ratio <dbl>, AQHI_o3_ratio <dbl>, AQHI_no2_ratio <dbl>,
      #   colour <chr>, risk <fct>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>

---

    Code
      aqhi_en_no_override
    Output
      # A tibble: 8,571 x 18
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>              <units>       <units>    <units>             <dbl>
       1 2018-01-01 09:00:00   NA          0.7        18.1                 NA  
       2 2018-01-01 10:00:00 12.1           NA        17.5                 NA  
       3 2018-01-01 11:00:00 10.7          0.2          NA                 11.4
       4 2018-01-01 12:00:00   NA           NA          NA                 11.4
       5 2018-01-01 13:00:00   NA           NA        16.6                 NA  
       6 2018-01-01 14:00:00  6.6           NA          NA                 NA  
       7 2018-01-01 15:00:00   NA          1.9          NA                 NA  
       8 2018-01-01 16:00:00  6.1          0.3        16.9                  6.3
       9 2018-01-01 17:00:00  7.1          1.0        18.1                  6.6
      10 2018-01-01 18:00:00  7.9          2.5        16.9                  7  
      # i 8,561 more rows
      # i 13 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>,
      #   AQHI_pm25_ratio <dbl>, AQHI_o3_ratio <dbl>, AQHI_no2_ratio <dbl>,
      #   colour <chr>, risk <fct>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>

---

    Code
      aqhi_plus_en
    Output
      # A tibble: 8,759 x 18
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>              <units>            <dbl>       <dbl>         <dbl>
       1 2018-01-01 09:00:00   NA                  NA          NA            NA
       2 2018-01-01 10:00:00 12.1                  NA          NA            NA
       3 2018-01-01 11:00:00 10.7                  NA          NA            NA
       4 2018-01-01 12:00:00   NA                  NA          NA            NA
       5 2018-01-01 13:00:00   NA                  NA          NA            NA
       6 2018-01-01 14:00:00  6.6                  NA          NA            NA
       7 2018-01-01 15:00:00   NA                  NA          NA            NA
       8 2018-01-01 16:00:00  6.1                  NA          NA            NA
       9 2018-01-01 17:00:00  7.1                  NA          NA            NA
      10 2018-01-01 18:00:00  7.9                  NA          NA            NA
      # i 8,749 more rows
      # i 13 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>,
      #   AQHI_pm25_ratio <dbl>, AQHI_o3_ratio <dbl>, AQHI_no2_ratio <dbl>,
      #   colour <chr>, risk <fct>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>

---

    Code
      aqhi_plus_fr
    Output
      # A tibble: 8,759 x 18
         date                pm25_1hr_ugm3 o3_1hr_ppb no2_1hr_ppb pm25_3hr_ugm3
         <dttm>              <units>            <dbl>       <dbl>         <dbl>
       1 2018-01-01 09:00:00   NA                  NA          NA            NA
       2 2018-01-01 10:00:00 12.1                  NA          NA            NA
       3 2018-01-01 11:00:00 10.7                  NA          NA            NA
       4 2018-01-01 12:00:00   NA                  NA          NA            NA
       5 2018-01-01 13:00:00   NA                  NA          NA            NA
       6 2018-01-01 14:00:00  6.6                  NA          NA            NA
       7 2018-01-01 15:00:00   NA                  NA          NA            NA
       8 2018-01-01 16:00:00  6.1                  NA          NA            NA
       9 2018-01-01 17:00:00  7.1                  NA          NA            NA
      10 2018-01-01 18:00:00  7.9                  NA          NA            NA
      # i 8,749 more rows
      # i 13 more variables: o3_3hr_ppb <dbl>, no2_3hr_ppb <dbl>, level <fct>,
      #   AQHI <fct>, AQHI_plus <fct>, AQHI_plus_exceeds_AQHI <lgl>,
      #   AQHI_pm25_ratio <dbl>, AQHI_o3_ratio <dbl>, AQHI_no2_ratio <dbl>,
      #   colour <chr>, risk <fct>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>

