# aqhi: Air Quality Health Index

<!-- badges: start -->

<!-- badges: end -->

The aqhi package provides reproducible calculations of the Air Quality Health Index (both AQHI and AQHI+), with French translations where possible.

## Installation

You can install the development version of aqhi from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("B-Nilson/aqhi")
```

## Examples

``` r
library(aqhi)

# Make test data
obs <- data.frame(
    date = seq(
        as.POSIXct("2024-01-01 00:00:00"),
        as.POSIXct("2024-01-01 23:00:00"),
        "1 hours"
    ),
    pm25 = 1:24,
    o3 = 1:24,
    no2 = 1:24
)

# Get detailed AQHI information
obs$date |> 
    AQHI(
        pm25_1hr_ugm3 = obs$pm25,
        o3_1hr_ppb = obs$o3,
        no2_1hr_ppb = obs$no2
    )
    
# Get just the AQHI
obs$date |> 
    AQHI(
        pm25_1hr_ugm3 = obs$pm25,
        o3_1hr_ppb = obs$o3,
        no2_1hr_ppb = obs$no2,
        detailed = FALSE
    )

# Return French translations
obs$date |> 
    AQHI(
        pm25_1hr_ugm3 = obs$pm25,
        o3_1hr_ppb = obs$o3,
        no2_1hr_ppb = obs$no2,
        language = "fr"
    )

# Get the AQHI+ (same form as AQHI)
obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25)
obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25, language = "fr")
obs$date |> AQHI(pm25_1hr_ugm3 = obs$pm25, detailed = FALSE)

# Or a trimmed down version specific to AQHI+
obs$pm25 |> AQHI_plus()
obs$pm25 |> AQHI_plus(language = "fr")
obs$pm25 |> AQHI_plus(detailed = FALSE)

# Get risk categories for AQHI levels
risk <- c(NA, 1:10, "+") |> get_risk_category()
risk_fr <- c(NA, 1:10, "+") |> get_risk_category(language = "fr")

# Get health messages for risk levels
risk |> get_health_messages()
risk_fr |> get_health_messages(language = "fr")

# View AQHI colours, risk categories, and health messages
AQHI_colours
AQHI_risk_category
AQHI_health_messages
```