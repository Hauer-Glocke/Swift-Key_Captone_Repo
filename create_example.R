create_example <- function(n=10000){
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", temp, mode="wb")
        
        con <- unz(temp, filename="final/en_US/en_US.twitter.txt")
        df_twitter <- readLines(con, n = n)
        close(con)
        
        con <- unz(temp, filename="final/en_US/en_US.news.txt")
        df_news <- readLines(con, n = n)
        close(con)
        
        con <- unz(temp, filename="final/en_US/en_US.blogs.txt")
        df_blogs <- readLines(con, n = n)
        close(con)
        
        saveRDS(df_twitter, "df_twitter_example.RDS")
        saveRDS(df_news, "df_news_example.RDS")
        saveRDS(df_blogs, "df_blogs_example.RDS")
        rm(list=ls())
}

read_files <- function(){
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", temp, mode="wb")
        
        con <- unz(temp, filename="final/en_US/en_US.twitter.txt")
        df_twitter <<- readLines(con)
        close(con)
        
        con <- unz(temp, filename="final/en_US/en_US.news.txt")
        df_news <<- readLines(con)
        close(con)
        
        con <- unz(temp, filename="final/en_US/en_US.blogs.txt")
        df_blogs <<- readLines(con)
        close(con)
}

read_examples <- function(){
        library(readr)
        df_twitter <<- read_rds("df_twitter_example.RDS")
        df_news <<- read_rds("df_news_example.RDS")
        df_blogs <<- read_rds("df_blogs_example.RDS")
}