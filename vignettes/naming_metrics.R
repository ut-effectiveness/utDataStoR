## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE, warning=FALSE, echo=FALSE---------------------------------
library(utMetrics)
library(tidyverse)
library(DT)

## ----echo=FALSE---------------------------------------------------------------
computations <- utMetrics::df_metrics_indices %>%
  select(computation) %>%
  arrange(computation) %>% 
  rename("Computation" = computation) %>% 
  unique()

datatable(computations)

## ----echo=FALSE---------------------------------------------------------------
partitions <- utMetrics::df_metrics_indices %>% 
  select(computation, partition) %>% 
  arrange(computation, partition) %>% 
  rename("Computation" = computation) %>% 
  rename("Partition" = partition) %>% 
  unique()

datatable(partitions)

## ----echo=FALSE---------------------------------------------------------------
metric_list <- utMetrics::df_metrics_indices %>% 
  select(metric, computation, partition, segment) %>% 
  arrange(computation, partition, segment) %>% 
  rename("Computation" = computation) %>% 
  rename("Partition" = partition) %>% 
  rename("Segment" = segment) %>% 
  unique()

datatable(metric_list)

