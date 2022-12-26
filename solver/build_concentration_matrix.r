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
W = DFDZ %*% PRESSURE  # W = dPdz (state vector)
# U (non-dimensional)
U = DFDR %*% PRESSURE # U = dPdr (state vector)
# Need: W_{j-1}

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
CONC_BV %<>% map_equations_to_b_vector(
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
    gridPoints = gridPoints_right
)
CONC_BV %<>% map_equations_to_b_vector(
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
CONC_BV %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = gam_g * (iota_coef * W * gamma_4 - beta_4),  
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_top
)

# bottom
CONC_BV %<>% map_equations_to_b_vector(
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
# Endothelial Cells
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Endothelial%20Cell.md
# ================================================== #
tmp_gam_g <- rep(rep(PE_ec * Lgstar / (dg * gam_g), rows_in_r), rows_in_z)
tmp_gam_i <- rep(rep(PE_ec * Listar / (di * gam_i), rows_in_r), rows_in_z)

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_6 - (W * iota_coef)
    ,ip1j = zeros
    ,im1j = omega_5 - tmp_gam_g
    ,ip2j = tmp_gam_i
    ,im2j = omega_4
    ,ijp1 = zeros
    ,ijm1 = zeros
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = ec1_gridPoints
)

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_3 - (W * iota_coef)
    ,ip1j = omega_2 + tmp_gam_i
    ,im1j = zeros 
    ,ip2j = omega_1
    ,im2j = NULL
    ,ijp1 = zeros 
    ,ijm1 = zeros 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = -tmp_gam_g # default value is zero and we have not edited this previously
    ,gridPoints = ec2_gridPoints
)

if(any(!is.finite(CONC_MAT@x))) {
	"Endothelial Cell" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}

# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Endothelial%20Cell%20-%20Normal%20Junction.md
# ================================================== #

# We need W_{j-1}, W_{j-2}, W_{j+1}
# W is a state-vector (row_1, ...m row_z)
# to get row prior we can just pad with fake row because we only care about endothelial cell
# ie. W_{j-1} = (fake-row, W_1, W_2, ..., W_{n-1})
# W_{j-2} = (fake-row, fake-row, W_1, W_2, ..., W_{n-2})
# W_{j+1} = (W_1, W_2, ..., W_{n-1}, fake-row)
# concatenate Matrix bc W is Mx1 matrix
# a<-matrix(nrow=10,ncol=5)
# b<-matrix(nrow=20,ncol=5)
# dim(rbind(a,b))

tmp_gam_g <- rep(rep(PE_nj * Lgstar / dg, rows_in_r), rows_in_z)
tmp_gam_i <- rep(rep(PE_nj * Listar / di, rows_in_r), rows_in_z)

W_jm1 <- W %>% shift_state_vector_in_z(-1)
W_jm2 <- W %>% shift_state_vector_in_z(-2)
W_jp1 <- W %>% shift_state_vector_in_z(1)
W_jp2 <- W %>% shift_state_vector_in_z(2)

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_6 - (W * iota_coef)
    ,ip1j = zeros
    ,im1j = omega_5 - (tmp_gam_g / gam_g) + dg_over_lg * (omega_6 - iota_coef * W_jm1) + (W * iota_coef * (1 - sigma_nj)) / (2 * fg)
    ,im2j = omega_4 + dg_over_lg * omega_5
    ,im3j = omega_4 * dg_over_lg
    ,ijp1 = zeros
    ,ijm1 = zeros
    ,ip2j = -(tmp_gam_g / gam_i) + di_over_li * (-omega_3 + iota_coef * W_jp2) - (W * iota_coef * (1 - sigma_nj)) / (2 * fg)
    ,ijm2 = zeros
    ,ip3j = - di_over_li * omega_2
    ,ip4j = - di_over_li * omega_1
    ,gridPoints = nj1_gridPoints
)



CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_3 - W * iota_coef
    ,ip1j = omega_2 + (tmp_gam_i / gam_i) - (W * iota_coef) * (1 / fi) * (1 - sigma_nj) * (1 / 2)
    ,im1j = zeros 
    ,ip2j = omega_1
    ,im2j = (W * iota_coef) * (gam_i / gam_g) * (1 / fi) * (1 - sigma_nj) * (1 / 2) - tmp_gam_i / gam_g
    ,ijp1 = zeros
    ,ijm1 = zeros 
    ,ijp2 = zeros 
    ,ijm2 = zeros 
    ,gridPoints = nj2_gridPoints
)

if(any(!is.finite(CONC_MAT@x))) {
	"Endothelial Cell - Normal Junction" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}

# ================================================== #
# Intima-Media boundary - Finestra hole
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Intima-Media%20Finestra.md
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

tmp_gam_i <- rep(rep(di / Listar, rows_in_r), rows_in_z) # it is okay to repeat only i because we only applying to 1 row of matrix 
tmp_gam_m <- rep(rep(dm / Lmstar, rows_in_r), rows_in_z) # it is okay to repeat only i because we only applying to 1 row of matrix 

# IM1
CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = tmp_gam_i * (-iota_coef * W + omega_3) + 1 / gam_i
    ,ip1j = -tmp_gam_m * (omega_6 + iota_coef * W) - 1 / gam_m
    ,im1j = tmp_gam_i * omega_2
    ,ip2j = -tmp_gam_m * omega_5
	,ip3j = -tmp_gam_m * omega_4
    ,im2j = tmp_gam_i * omega_1
    ,ijp1 = zeros
    ,ijm1 = zeros
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = intima_bottom_gridPoints
)

# IM2
CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = tmp_gam_m * (-omega_6 + iota_coef * W) - 1 / gam_m
    ,ip1j = -tmp_gam_m * omega_5
    ,im1j = tmp_gam_i * (omega_3 - iota_coef * W) + 1 / gam_i 
    ,ip2j = -tmp_gam_m * omega_4
    ,im2j = tmp_gam_i * omega_2
	,im3j = tmp_gam_i * omega_1
    ,ijp1 = zeros 
    ,ijm1 = zeros 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = media_top_gridPoints
)


if(any(!is.finite(CONC_MAT@x))) {
	"Intima-Media Finestra" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}

# ================================================== #
# Intima-Media boundary - Non-Finestra
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Intima-Media%20Non-Finestra.md
# ================================================== #

non_finestra_sequence_r = seq(first_non_finestra_cell, last_non_finestra_cell)
not_finestra_intima_bottom_gridPoints = expand.grid(136, non_finestra_sequence_r)
not_finestra_media_top_gridPoints = expand.grid(137, non_finestra_sequence_r) 

tmp_gam_g <- rep(rep(PE_nj * Lgstar / (dg * gam_g), rows_in_r), rows_in_z)
tmp_gam_i <- rep(rep(PE_nj * Listar / (di * gam_i), rows_in_r), rows_in_z)


tmp_gam_m * (-omega_6 + iota_coef * W) - 1 / gam_m

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_6
    ,ip1j = zeros
    ,im1j = omega_5
    ,ip2j = NULL
    ,im2j = omega_4
    ,ijp1 = zeros
    ,ijm1 = zeros
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = not_finestra_intima_bottom_gridPoints
)

CONC_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_3
    ,ip1j = omega_2
    ,im1j = zeros 
    ,ip2j = NULL
    ,im2j = NULL
    ,ijp1 = omega_1 
    ,ijm1 = zeros 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = not_finestra_media_top_gridPoints
)

if(any(!is.finite(CONC_MAT@x))) {
	"Intima-Media Non-Finestra" %>% sprintf("ERROR: Non-finite values entered in concentration matrix @ %s", .) %>% stop()
}

