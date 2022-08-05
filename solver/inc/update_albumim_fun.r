

pressure_bv_albumim_updater <- function(PRESSURE_BV, CONCENTRATION){
	# ============================================= # 
	# Updating Albumim concentrations	
	# ============================================= #
	# gx + intima for ec_top
	PRESSURE_BV[ index_ec1[, 1] ] <- PRESSURE_BV[ index_ec1[, 1] ] + (sigma_EC * xi_g_ec) * CONCENTRATION[ index_intima_from_ec1[, 2] ] + (-sigma_EC * xi_g_ec) * CONCENTRATION[ index_gx_from_ec1[, 2] ]
	# gx + intima for ec_bot
	PRESSURE_BV[ index_ec2[, 1] ] <- PRESSURE_BV[ index_ec2[, 1] ] + (sigma_EC * xi_i_ec) * CONCENTRATION[ index_intima_from_ec2[, 2] ] + (-sigma_EC * xi_i_ec) * CONCENTRATION[ index_gx_from_ec2[, 2] ]

	# --------- Normal-Junction ------------
	# No Concentration in equation for EC1
	# gx + intima for nj_bot
	PRESSURE_BV[ index_nj2[, 1] ] <- PRESSURE_BV[ index_nj2[, 1] ] + (sigma_EC * xi_nj) * CONCENTRATION[ index_intima_from_nj2[, 2] ] + (-sigma_EC * xi_nj) * CONCENTRATION[ index_gx_from_nj2[, 2] ]
	
	PRESSURE_BV %>% return
}



