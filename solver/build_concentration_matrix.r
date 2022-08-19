# ======================================================== #
# Overview
# ======================================================== #

# Apply equations to concentration matrix and concentration boundary-vector in grid space 
# See docs for more information, equations, and more in-depth comments
# Docs: https://github.com/fschiro/DRumshitzki/tree/main/docs

# grid-space = (i, j) = (rows, columns) = (r, z)
# 	i, j = [row, column] of grid space
# 	i = dz
# 	j = dr 

# ======================================================== #
# Create initial sparse-matrices
# ======================================================== #

CONC_MAT <- Matrix(nrow = gridDimension, ncol = gridDimension, data = 0, sparse = TRUE)
CONC_BV <- Matrix(nrow = gridDimension, ncol = 1, data = 0, sparse = TRUE)

# W (non-dimensional)
W = DFDZ %*% PRESSURE  # W = dPdz
# U (non-dimensional)
U = DFDR %*% PRESSURE # U = dPdr

# =========================================================================================================================== #
# Main equations over all points
# Source: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Interior%20Grid%20Points.md
# =========================================================================================================================== #
# betaAlt_i = H_SQR * beta_i, gammaAlt_i = H_SQR * gamma_i
# iota_coef = (fj x Pl* x Kpj) / ( gam_j x Dj* x Mu) 

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = (iota_coef * gammaAlt_2 * U) + (iota_coef * W * gamma_5 ) - betaAlt_2 - (gammaAlt_2 * r_inverse) - beta_5,
    ip1j = (iota_coef * W * gamma_6) - beta_6, 
    im1j = (iota_coef * W * gamma_4) - beta_4, 
    ijp1 = (iota_coef * U * gammaAlt_3) - betaAlt_3 - (r_inverse * gammaAlt_3), 
    ijm1 = (iota_coef * gammaAlt_1 * U) - betaAlt_1 - (r_inverse * gammaAlt_1), 
    gridPoints = NULL # Null sets to all points on interior
)

# ================================================== #
# Left + right boundaries
# ================================================== #

gridPoints_left = expand.grid(seq(rows_in_z), 1)
gridPoints_right = expand.grid(seq(rows_in_z), rows_in_r)

# Right
CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = iota_coef * W * gamma_5 - betaAlt_2 - beta_5, 
    ip1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite
    im1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite.
    ijp1 = -betaAlt_3,
    ijm1 = -betaAlt_1,
    gridPoints = gridPoints_left
)
CONC_MAT %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = NULL, 
    ijm1 = -betaAlt_1, 
    gridPoints = gridPoints_left
)

# Left
CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = iota_coef * W * gamma_5 - betaAlt_2 - beta_5, 
    ip1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite
    im1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite.
    ijp1 = -betaAlt_3,
    ijm1 = -betaAlt_1,
    gridPoints = gridPoints_right = 
)
CONC_MAT %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r, 
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = -betaAlt_3, 
    ijm1 = NULL, 
    gridPoints = gridPoints_right
)




# ================================================================================================================================= #
# Top, bottom boundaries
# Source: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Top%20%26%20Bottom%20Boundaries.md
# ================================================================================================================================= #


gridPoints_top = expand.grid(1, seq(rows_in_r))
gridPoints_bot = expand.grid(rows_in_z, seq(rows_in_r))

# top
CONC_MAT %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = gam_g * (iota_coef * W * gamma_4 - beta_4),  
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_top
)

# bottom
CONC_MAT %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = gam_m * (iota_coef * W * gamma_6 - beta_6), 
    im1j = NULL,  
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_bot
)

if(any(!is.finite(CONC_MAT@x))) {
	"Interior or outer boundaries" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}


# ================================================== #
# Intima-Media boundary - Finestra hole
# Docs: 
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

if(any(!is.finite(CONC_MAT@x))) {
	"Intima-Media Finestra" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}


# ================================================== #
# Intima-Media boundary - Non-Finestra
# Docs:
# ================================================== #

non_finestra_sequence_r = seq(first_non_finestra_cell, last_non_finestra_cell)
not_finestra_intima_bottom_gridPoints = expand.grid(136, non_finestra_sequence_r)
not_finestra_media_top_gridPoints = expand.grid(137, non_finestra_sequence_r) 


if(any(!is.finite(CONC_MAT@x))) {
	"Intima-Media Non-Finestra" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}


# ================================================== #
# Endothelial Cells
# Docs: 
# ================================================== #

if(any(!is.finite(CONC_MAT@x))) {
	"Endothelial Cell" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}

# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# Docs: 
# ================================================== #

if(any(!is.finite(CONC_MAT@x))) {
	"Endothelial Cell - Normal Junction" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}
