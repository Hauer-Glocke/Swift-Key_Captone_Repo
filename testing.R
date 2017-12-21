library(readr)

blogs <- readlines(,10000)
save_rds

#Testdata
blogs <- read_rds("df_blogs_test.RDS")
news <- read_rds("df_news_test.RDS")
twitter <- read_rds("df_twitter_test.RDS")

#Realdata
load("text_to_upload.RData")