# AQHI+ returns expected output

    Code
      AQHI_plus(pm25_hourly, detailed = TRUE)
    Output
      # A tibble: 24 x 6
         pm25_1hr_ugm3 level colour  risk    high_risk_pop_message general_pop_message
                 <dbl> <fct> <chr>   <fct>   <chr>                 <chr>              
       1          NA   <NA>  <NA>    <NA>    <NA>                  <NA>               
       2          NA   <NA>  <NA>    <NA>    <NA>                  <NA>               
       3           0   1     #21C6F5 Low     Enjoy your usual act~ Ideal air quality ~
       4           0.1 1     #21C6F5 Low     Enjoy your usual act~ Ideal air quality ~
       5          10   1     #21C6F5 Low     Enjoy your usual act~ Ideal air quality ~
       6          10.1 2     #189ACA Low     Enjoy your usual act~ Ideal air quality ~
       7          20   2     #189ACA Low     Enjoy your usual act~ Ideal air quality ~
       8          20.1 3     #0D6797 Low     Enjoy your usual act~ Ideal air quality ~
       9          30   3     #0D6797 Low     Enjoy your usual act~ Ideal air quality ~
      10          30.1 4     #FFFD37 Modera~ Consider reducing or~ No need to modify ~
      # i 14 more rows

---

    Code
      AQHI_plus(pm25_hourly, detailed = TRUE, language = "fr")
    Output
      # A tibble: 24 x 6
         pm25_1hr_ugm3 level colour  risk   high_risk_pop_message  general_pop_message
                 <dbl> <fct> <chr>   <fct>  <chr>                  <chr>              
       1          NA   <NA>  <NA>    <NA>   <NA>                   <NA>               
       2          NA   <NA>  <NA>    <NA>   <NA>                   <NA>               
       3           0   1     #21C6F5 Faible Profiter des activité~ Qualité de l'air i~
       4           0.1 1     #21C6F5 Faible Profiter des activité~ Qualité de l'air i~
       5          10   1     #21C6F5 Faible Profiter des activité~ Qualité de l'air i~
       6          10.1 2     #189ACA Faible Profiter des activité~ Qualité de l'air i~
       7          20   2     #189ACA Faible Profiter des activité~ Qualité de l'air i~
       8          20.1 3     #0D6797 Faible Profiter des activité~ Qualité de l'air i~
       9          30   3     #0D6797 Faible Profiter des activité~ Qualité de l'air i~
      10          30.1 4     #FFFD37 Modéré Envisagez de réduire ~ Aucun besoin de mo~
      # i 14 more rows

