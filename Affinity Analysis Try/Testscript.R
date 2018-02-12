# Source: https://exploratory.io/viz/yosuke/3611806196832895?cb=1475668226988

# Load required packages.
library(lubridate)
library(hms)
library(tidyr)
library(urltools)
library(stringr)
library(readr)
library(broom)
library(RcppRoll)
library(tibble)
library(dplyr)
library(exploratory)

# Data Analysis Steps
test <- read_delim("groceries.csv" , 
                   ",", 
                   quote = "\"", 
                   skip = 0 ,
                   col_names = FALSE , 
                   na = c("","NA") , 
                   locale=locale(encoding = "ASCII", 
                                 decimal_mark = "."), 
                   trim_ws = FALSE , 
                   progress = FALSE) %>%
        exploratory::clean_data_frame() %>%
        mutate(transaction_id = row_number()) %>%
        gather(key, product, -transaction_id, na.rm = TRUE) %>%
        arrange(transaction_id) %>%
        do_apriori(product, transaction_id, min_support = 0.0001) %>%
        filter(support > 0.0004) %>%
        group_by(rhs) %>%
        top_n(3, lift)
