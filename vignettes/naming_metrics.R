## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE--------------------------------------------------------
library(utMetrics)

## ----message=FALSE, warning=FALSE, echo=FALSE---------------------------------
library(tidyverse)
library(DT)

## ----echo=FALSE---------------------------------------------------------------
metric_groups <- utMetrics::df_index %>% 
  select(metric_group) %>% 
  arrange(metric_group) %>%
  rename("Metric Group" = metric_group) %>% 
  unique()

datatable(metric_groups)

## ----echo=FALSE---------------------------------------------------------------
metric_partitions <- utMetrics::df_index %>% 
  select(metric_group, segmented_by) %>% 
  arrange(metric_group, segmented_by) %>% 
  rename("Metric Group" = metric_group) %>% 
  rename("Partition" = segmented_by) %>% 
  unique()

datatable(metric_partitions)

## ----echo=FALSE---------------------------------------------------------------
metric_list <- utMetrics::df_metric_group_full_segment %>% 
  select(metric_group, segmented_by, segment) %>% 
  arrange(metric_group, segmented_by, segment) %>% 
  rename("Metric Group" = metric_group) %>% 
  rename("Partition" = segmented_by) %>% 
  rename("Segment" = segment) %>% 
  unique()

datatable(metric_list)

