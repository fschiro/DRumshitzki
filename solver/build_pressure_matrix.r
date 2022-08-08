# ======================================================== #
# Overview
# ======================================================== #

# Apply equations to pressure matrix and pressure boundary-vector in grid space 
# See docs for more information, equations, and more in-depth comments
# Docs: https://github.com/fschiro/DRumshitzki/tree/main/docs

# grid-space = (i, j) = (rows, columns) = (r, z)
# 	i, j = [row, column] of grid space
# 	i = dz
# 	j = dr 

# ======================================================== #
# Create initial sparse-matrices
# ======================================================== #

PRESSURE_MAT <- Matrix(nrow = gridDimension, ncol = gridDimension, data = 0, sparse = TRUE)
PRESSURE_BV <- Matrix(nrow = gridDimension, ncol = 1, data = 0, sparse = TRUE)

# ================================================== #
# Main equations over all points
# ================================================== #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = betaAlt_2 + gammaAlt_2 + beta_5, 
    ip1j = beta_6, 
    im1j = beta_4, 
    ijp1 = betaAlt_3 + gammaAlt_3, 
    ijm1 = betaAlt_1 + gammaAlt_1, 
    gridPoints = NULL # Null sets to all points on interior
)

# ================================================== #
# Left + right boundaries
# ================================================== #
# ------- Equations ------- #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0
# axisymmetric -> P(0, z) = P(r_max, z)
# D(P, r) = 0
# ------- Notes ------- #
# Question: Why must we modify A? 
# 	Answer: 
#		Overwrite ij in A because D(P, r) = 0
# 		Overwrite ijm1 @ left gridpoints because D(P, r) = 0
# 		Overwrite ijp1 @ right gridpoints because D(P, r) = 0
# ================================================== #

gridPoints_left = expand.grid(seq(rows_in_z), 1)
gridPoints_right = expand.grid(seq(rows_in_z), rows_in_r)

# Right
PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = betaAlt_2 + beta_5, 
    ip1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite
    im1j = NULL, # don't need - correctly applied previously in interior section & NULL does not overwrite.
    ijp1 = NULL, # don't need to overwrite BC point not on grid so nothing to overwrite
    ijm1 = betaAlt_1,
    gridPoints = gridPoints_left
)
PRESSURE_BV %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = NULL, 
    ijm1 = betaAlt_1, 
    gridPoints = gridPoints_left
)

# Left
PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = betaAlt_2 + beta_5, 
    ip1j = NULL, # don't need - correctly applied previously in interior section
    im1j = NULL, # don't need - correctly applied previously in interior section
    ijp1 = betaAlt_3, 
    ijm1 = NULL, # don't need, this point not in grid
    gridPoints = gridPoints_right
)
PRESSURE_BV %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r, 
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = betaAlt_3, 
    ijm1 = NULL, 
    gridPoints = gridPoints_right
)

# ================================================== #
# Top, bottom boundaries
# ================================================== #
# ------- Equations ------- #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0
# Pg = 1 @ z = GX top
# Pm = 0 @ z = Media bottom
# ------- Notes ------- #
# Question: Why don't we modify A? 
# 	Answer: 
#		A does not change
#		Top and bottom boundaries are constants
#		These points are not in grid no mod needed
# Question: Why don't we modify B for bottom boundary?
#	Answer: value of pressure is zero at boundary
#			B is already correct BC default iz zero
# ================================================== #

gridPoints_top = expand.grid(1, seq(rows_in_r))
gridPoints_bot = expand.grid(rows_in_z, seq(rows_in_r))

# top
PRESSURE_BV %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = beta_4,  
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_top
)

# bottom not needed

if(any(!is.finite(PRESSURE_MAT@x))) {
	"Interior or outer boundaries" %>% sprintf("ERROR: Non-finite values entered in pressure matrix @ %s", .) %>% stop()
}

# ================================================== #
# Intima-Media boundary - Finestra hole
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Intima-Media%20Finestra.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = Kpi * omega_6 + Kpm * omega_3 + Kpm * omega_2
    ,im1j = Kpi * omega_5
    ,im2j = Kpi * omega_4
    ,ip1j = NULL # default value is zero and we have not edited this previously
    ,ip2j = Kpm * omega_1
    ,ip3j = NULL # default value is zero and we have not edited this previously
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,ijp1 = NULL # default value is zero and we have not edited this previously 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = intima_bottom_gridPoints
)

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = Kpi * omega_5 + Kpi * omega_6 + Kpm * omega_3
    ,im1j = NULL # default value is zero and we have not edited this previously
    ,im2j = Kpi * omega_4
    ,ip1j = Kpm * omega_2
    ,ip2j = Kpm * omega_1
    ,ip3j = NULL # default value is zero and we have not edited this previously
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,ijp1 = NULL # default value is zero and we have not edited this previously 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = media_top_gridPoints
)

if(any(!is.finite(PRESSURE_MAT@x))) {
	"Intima-Media Finestra" %>% sprintf("ERROR: Non-finite values entered in pressure matrix @ %s", .) %>% stop()
}


# ================================================== #
# Intima-Media boundary - Non-Finestra
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Intima-Media%20Non-Finestra.md
# ================================================== #
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #

non_finestra_sequence_r = seq(first_non_finestra_cell, last_non_finestra_cell)
not_finestra_intima_bottom_gridPoints = expand.grid(136, non_finestra_sequence_r)
not_finestra_media_top_gridPoints = expand.grid(137, non_finestra_sequence_r) 



PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_6
    ,im1j = omega_5
    ,im2j = omega_4
    ,ip1j = NULL # default value is zero and we have not edited this previously
    ,ip2j = NULL # default value is zero and we have not edited this previously
    ,ip3j = NULL # default value is zero and we have not edited this previously
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,ijp1 = NULL # default value is zero and we have not edited this previously 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = not_finestra_intima_bottom_gridPoints
)

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_3
    ,im1j = NULL # default value is zero and we have not edited this previously
    ,im2j = NULL # default value is zero and we have not edited this previously
    ,ip1j = omega_2
    ,ip2j = omega_1
    ,ip3j = NULL # default value is zero and we have not edited this previously
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,ijp1 = NULL # default value is zero and we have not edited this previously 
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = not_finestra_media_top_gridPoints
)


if(any(!is.finite(PRESSURE_MAT@x))) {
	"Intima-Media Non-Finestra" %>% sprintf("ERROR: Non-finite values entered in pressure matrix @ %s", .) %>% stop()
}


# ================================================== #
# Endothelial Cells
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_6,
    ip1j = zeros,
    im1j = omega_5 + xi_g_ec,
    ip2j = -xi_g_ec * ones,
    im2j = omega_4,
    ijp1 = NULL, # default value is zero and we have not edited this previously 
    ijm1 = NULL, # default value is zero and we have not edited this previously
    ijp2 = NULL, # default value is zero and we have not edited this previously
    ijm2 = NULL, # default value is zero and we have not edited this previously
    gridPoints = ec1_gridPoints
)

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_3,
    ip1j = omega_2 - xi_i_ec,
    im1j = NULL, # default value is zero and we have not edited this previously
    ip2j = omega_1,
    im2j = xi_i_ec * ones,
    ijp1 = NULL, # default value is zero and we have not edited this previously 
    ijm1 = NULL, # default value is zero and we have not edited this previously
    ijp2 = NULL, # default value is zero and we have not edited this previously
    ijm2 = NULL, # default value is zero and we have not edited this previously
    gridPoints = ec2_gridPoints
)

if(any(!is.finite(PRESSURE_MAT@x))) {
	"Endothelial Cell" %>% sprintf("ERROR: Non-finite values entered in pressure matrix @ %s", .) %>% stop()
}

# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell%20Normal%20Junction.md
# ================================================== #
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ,ij = -Kpg * omega_6
    ,im1j = -Kpg * omega_5
    ,im2j = -Kpg * omega_4
    ,ip1j = Kpg * omega_3
    ,ip2j = Kpg * omega_2
    ,ip3j = Kpg * omega_1
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,ijp1 = NULL # default value is zero and we have not edited this previously
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = nj1_gridPoints
)

PRESSURE_MAT %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = Kpi * omega_3 - omega_3
    ,ip1j = Kpi * omega_2 - omega_2
    ,ip2j = Kpi * omega_1 - omega_1
    ,ip3j = zeros
    ,im1j = -Kpg * omega_6
    ,im2j = -Kpg * omega_5 + xi_nj
    ,im3j = -Kpg * omega_4
    ,ijp1 = NULL # default value is zero and we have not edited this previously
    ,ijm1 = NULL # default value is zero and we have not edited this previously
    ,ijp2 = NULL # default value is zero and we have not edited this previously
    ,ijm2 = NULL # default value is zero and we have not edited this previously
    ,gridPoints = nj2_gridPoints
)

if(any(!is.finite(PRESSURE_MAT@x))) {
	"Endothelial Cell - Normal Junction" %>% sprintf("ERROR: Non-finite values entered in pressure matrix @ %s", .) %>% stop()
}

# i = dz
# j = dr 
