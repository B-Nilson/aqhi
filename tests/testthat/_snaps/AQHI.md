# AQHI returns expected output

    Code
      AQHI(dates = obs$date, pm25_1hr_ugm3 = obs$pm25, o3_1hr_ppb = obs$o3,
      no2_1hr_ppb = obs$no2, verbose = FALSE)
    Output
      # A tibble: 24 x 15
         date                 pm25    o3   no2 pm25_rolling_3hr no2_rolling_3hr
         <dttm>              <int> <int> <int>            <dbl>           <dbl>
       1 2024-01-01 00:00:00     1     1     1               NA              NA
       2 2024-01-01 01:00:00     2     2     2               NA              NA
       3 2024-01-01 02:00:00     3     3     3                2               2
       4 2024-01-01 03:00:00     4     4     4                3               3
       5 2024-01-01 04:00:00     5     5     5                4               4
       6 2024-01-01 05:00:00     6     6     6                5               5
       7 2024-01-01 06:00:00     7     7     7                6               6
       8 2024-01-01 07:00:00     8     8     8                7               7
       9 2024-01-01 08:00:00     9     9     9                8               8
      10 2024-01-01 09:00:00    10    10    10                9               9
      # i 14 more rows
      # i 9 more variables: o3_rolling_3hr <dbl>, level <int>, AQHI <fct>,
      #   AQHI_plus <fct>, risk <int>, colour <chr>, high_risk_pop_message <chr>,
      #   general_pop_message <chr>, AQHI_plus_exceeds_AQHI <lgl>

---

    Code
      AQHI(dates = obs$date, pm25_1hr_ugm3 = obs$pm25, verbose = FALSE)
    Output
      # A tibble: 24 x 9
         pm25_1hr_ugm3 level AQHI  AQHI_plus colour  risk  high_risk_pop_message      
                 <int> <fct> <lgl> <fct>     <chr>   <fct> <chr>                      
       1             1 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       2             2 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       3             3 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       4             4 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       5             5 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       6             6 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       7             7 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       8             8 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
       9             9 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
      10            10 1     NA    1         #21C6F5 Low   Enjoy your usual activitie~
      # i 14 more rows
      # i 2 more variables: general_pop_message <chr>, AQHI_plus_exceeds_AQHI <lgl>

