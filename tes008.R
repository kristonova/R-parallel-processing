library(sna)
library(igraph)
library(textclean)
library(tidyverse)

setwd("/home/kristo/R-parallel-processing")
num_r <- read.dot("collatz.dot")
g.graph <- graph.adjacency(num_r)

angka <- V(g.graph)$name
angka <- gsub(";", "", angka)
angka <- replace_white(angka)
angka <- as.numeric(angka)
angka <- data_frame(angka)
angka <- angka %>% 
  filter(!duplicated(angka))

kamus <- data_frame(k1 = seq_along(1:2100000000))

kamus1 <- kamus %>%
  mutate(komplit_1 = (18*k1)+4, # 1st complete condition
         komplit_2 = (18*k1)-2, # 2st complete condition
  )

hasil_1 <- kamus1 %>%
  filter(komplit_1 %in% angka$angka) %>% 
  select(angka = komplit_1)

hasil_2 <- kamus1 %>%
  filter(komplit_2 %in% angka$angka) %>% 
  select(angka = komplit_2)

# gabungan nodes yang komplit
komplit <- bind_rows(hasil_1, hasil_2)
komplit <- komplit %>% 
  filter(!duplicated(angka)) %>% 
  mutate(ket = "komplit")

# nodes yang tidak komplit
tdk_komplit <- angka %>% 
  filter(!angka %in% komplit$angka) %>% 
  mutate(ket = "tidak komplit")

hasil_total <- bind_rows(komplit, tdk_komplit)

hasil_total
