# 2023/09/22
# Ville Inkinen
# BIOADD Work Package 2

# Element-wise addition and subtraction that ignores NA values. Returns NA if both inputs are NA. Useful with data.table.

`%+na%` <- function(x,y) ifelse(is.na(x), y, ifelse(is.na(y), x, x + y)) 

`%-na%` <- function(x,y) ifelse(is.na(x), y, ifelse(is.na(y), x, x - y)) 
