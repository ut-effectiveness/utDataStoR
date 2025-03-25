## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message=FALSE, warning=FALSE, echo=FALSE---------------------------------
library(utMetrics)
library(tidyverse)
library(DT)

## ----echo=FALSE, out.width = "55%", fig.align = "center"----------------------
knitr::include_graphics("metrics.png")

## ----echo=FALSE---------------------------------------------------------------
computations <- utMetrics::df_metrics_indices %>%
  select(computation) %>%
  arrange(computation) %>% 
  rename("Computation" = computation) %>% 
  unique()

datatable(computations)

