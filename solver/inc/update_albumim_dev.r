

# ============================================= # 
# Updating Albumim concentrations
# I'm unsure if index is correct maybe should just be the gridpoints 
# ============================================= #

# --------- endothelial cell ------------
index_ec_top <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_ec_bottom <- ec_bottom_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_intimA <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = 2)) %>% do.call(rbind, .) %>% .[, 1]
index_gx <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = -1)) %>% do.call(rbind, .) %>% .[, 1]

# gx + intima for ec_top
PRESSURE_BV[ index_ec_top ] <- PRESSURE_BV[ index_ec_top ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]
# gx + intima for ec_bot
PRESSURE_BV[ index_ec_bottom ] <- PRESSURE_BV[ index_ec_bottom ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]

# --------- Normal-Junction ------------
index_nj_top <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_nj_bottom <- nj_bottom_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_intimA <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = 2)) %>% do.call(rbind, .) %>% .[, 1]
index_gx <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = -1)) %>% do.call(rbind, .) %>% .[, 1]

# gx + intima for nj_top
PRESSURE_BV[ index_nj_top ] <- PRESSURE_BV[ index_nj_top ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]
# gx + intima for nj_bot
PRESSURE_BV[ index_nj_bottom ] <- PRESSURE_BV[ index_nj_bottom ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]
