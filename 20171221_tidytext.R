##Application of TIDYTEXT Analysis (https://www.tidytextmining.com/tidytext.html)

#Empty Environment
rm(list=ls())
cat("\f")

#Packages
library(readr)
library(dplyr)
library(tidytext)
library(ggplot2)
library(tidyr)
library(scales)
library(stringr)

#Testdata
source('create_example.R')
read_examples()

df_blogs <- data_frame(line = 1:length(df_blogs), text = df_blogs)
df_news <- data_frame(line = 1:length(df_news), text = df_news)
df_twitter <- data_frame(line = 1:length(df_twitter), text = df_twitter)

df_blogs <- df_blogs %>% unnest_tokens(word, text) %>% anti_join(stop_words)
df_news <- df_news %>% unnest_tokens(word, text) %>% anti_join(stop_words)
df_twitter <- df_twitter %>% unnest_tokens(word, text) %>% anti_join(stop_words)

df_twitter_1w <- unlist(tokenize_ngrams(df_twitter, n=1, simplify=TRUE))
df_twitter_2w <- unlist(tokenize_ngrams(df_twitter, n=2, simplify=TRUE))
df_twitter_3w <- unlist(tokenize_ngrams(df_twitter, n=3, simplify=TRUE))

library(tm)
library(textmineR)
library(tokenizers)
my_tokenizer <- textmineR::NgramTokenizer(min=2, max=3)
df_twitter_2w <- tm::DocumentTermMatrix(corp, df_twitter=list(tokenize=my_tokenizer))
df_twitter_2w <- MakeSparseDTM(df_twitter_2w)

#Realdata
load("text_to_upload.RData")
df_blogs <- data_frame(line = 1:length(df_blogs), text = df_blogs)
df_news <- data_frame(line = 1:length(df_news), text = df_news)
df_twitter <- data_frame(line = 1:length(df_twitter), text = df_twitter)
df_blogs <- df_blogs %>% unnest_tokens(word, text) %>% anti_join(stop_words)
df_news <- df_news %>% unnest_tokens(word, text) %>% anti_join(stop_words)
df_twitter <- df_twitter %>% unnest_tokens(word, text) %>% anti_join(stop_words)

##WORD COUNT
#df_blogs %>% count(word, sort = TRUE)
#df_news %>% count(word, sort = TRUE) 
#df_twitter %>% count(word, sort = TRUE)

df_blogs %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE) %>%
        head(10) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(word, n)) +
        geom_col() +
        xlab(NULL) +
        coord_flip() +
        ggtitle('Top 10 Words in Blogs')

df_news %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE) %>%
        head(10) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(word, n)) +
        geom_col() +
        xlab(NULL) +
        coord_flip() +
        ggtitle('Top 10 Words in News')

df_twitter %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE) %>%
        head(10) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(word, n)) +
        geom_col() +
        xlab(NULL) +
        coord_flip() +
        ggtitle('Top 10 Words on Twitter')

###########################

frequency <- bind_rows(mutate(df_blogs, author = "Blogs"),
                       mutate(df_news, author = "News"), 
                       mutate(df_twitter, author = "Twitter")) %>% 
        mutate(word = str_extract(word, "[a-z']+")) %>%
        count(author, word) %>%
        group_by(author) %>%
        mutate(proportion = n / sum(n)) %>% 
        select(-n) %>% 
        spread(author, proportion) %>% 
        gather(author, proportion, `Blogs`:`News`)

ggplot(frequency, aes(x = proportion, y = `Twitter`, color = abs(`Twitter` - proportion))) +
        geom_abline(color = "gray40", lty = 2) +
        geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
        geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
        scale_x_log10(labels = percent_format()) +
        scale_y_log10(labels = percent_format()) +
        scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
        facet_wrap(~author, ncol = 2) +
        theme(legend.position="none") +
        labs(y = "Twitter", x = NULL)

cor.test(data = frequency[frequency$author == "Blogs",],
         ~ proportion + `Twitter`)$estimate

cor.test(data = frequency[frequency$author == "News",], 
         ~ proportion + `Twitter`)$estimate


############OLD from Assignment1.Rmd


df_blogs <- data_frame(line = 1:length(df_blogs), text = df_blogs)
df_blogs <- df_blogs %>% unnest_tokens(word, text) %>% anti_join(stop_words)

df_news <- data_frame(line = 1:length(df_news), text = df_news)
df_news <- df_news %>% unnest_tokens(word, text) %>% anti_join(stop_words)

df_twitter <- data_frame(line = 1:length(df_twitter), text = df_twitter)
df_twitter <- df_twitter %>% unnest_tokens(word, text) %>% anti_join(stop_words)
