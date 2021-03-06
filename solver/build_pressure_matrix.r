# ======================================================== #
# Overview
# ======================================================== #

# Apply equations to pressure matrix and pressure boundary-vector in grid space 

# Grid space in r:
#   Endothelial Cell region:
#      EC r in [0, R]
#      Normal-Junction r in (R, end]
#      R = 737
#          rGridStuff$pec = 737 -> R = 737
#      end = 773

#   Non-endothelial cell region:
#      Finestra r in [0, 1]
#      Non-Finestra r in (1, end]
#      finestra r in [0, 89]
#          rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773

# Grid space in z:
#   Glycocalyx: z in [0, 49]
#   EC: z in [50, 51] 
#       length(z_g) = 49 -> 50 + 51 are endothelial cells
#   Intima:
#   Media: 

# grid-space = (i, j) = (rows, columns) = (r, z)
#	 i, j = [row, column] of grid space -> dr = dj, dz = di
# Matrix-space conversion = handled automatically
#   These functions return -1 when out point out-of-grid
#   All points in grid are not boundary (they may be adjacent to boundary)



# ======================================================== #
# Framework
# ======================================================== #
# Write a little about how this works on github and paste source link here

# i = dz
# j = dr 


dimA <- rows_in_z * rows_in_r
PRESSURE <- Matrix(nrow = dimA, ncol = dimA, data = 0, sparse = TRUE)
PRESSURE_BV <- Matrix(nrow = dimA, ncol = 1, data = 0, sparse = TRUE)



# ================================================== #
# Main equations over all points
# ================================================== #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0

PRESSURE %<>% map_equations_to_matrix(
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
PRESSURE %<>% map_equations_to_matrix(
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
PRESSURE %<>% map_equations_to_matrix(
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





# ================================================== #
# Intima-Media boundary - Finestra hole
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Intima-Media%20Finestra.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

PRESSURE %<>% map_equations_to_matrix(
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

PRESSURE %<>% map_equations_to_matrix(
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



# ================================================== #
# Intima-Media boundary - Non-Finestra
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Intima-Media%20Non-Finestra.md
# ================================================== #
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773
# rGridStuff$pec = 737 -> R = 737 -> first 737 / 773 points are on EC
# ================================================== #

non_finestra_sequence_r = seq(first_non_finestra_cell, last_non_finestra_cell)
not_finestra_intima_bottom_gridPoints = expand.grid(136, non_finestra_sequence_r)
not_finestra_media_top_gridPoints = expand.grid(137, non_finestra_sequence_r) 



PRESSURE %<>% map_equations_to_matrix(
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

PRESSURE %<>% map_equations_to_matrix(
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




# ================================================== #
# Endothelial Cells
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #

ec_top_gridPoints = expand.grid(50, seq(last_endo_cell)) 
ec_bottom_gridPoints = expand.grid(51, seq(last_endo_cell))

PRESSURE %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_6,
    ip1j = zeros,
    im1j = omega_5 + xi_g_ec,
    ip2j = -xi_g_ec,
    im2j = omega_4,
    ijp1 = NULL, # default value is zero and we have not edited this previously 
    ijm1 = NULL, # default value is zero and we have not edited this previously
    ijp2 = NULL, # default value is zero and we have not edited this previously
    ijm2 = NULL, # default value is zero and we have not edited this previously
    gridPoints = ec_top_gridPoints
)

PRESSURE %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_3,
    ip1j = omega_2 - xi_i_ec,
    im1j = NULL, # default value is zero and we have not edited this previously
    ip2j = omega_1,
    im2j = xi_i_ec,
    ijp1 = NULL, # default value is zero and we have not edited this previously 
    ijm1 = NULL, # default value is zero and we have not edited this previously
    ijp2 = NULL, # default value is zero and we have not edited this previously
    ijm2 = NULL, # default value is zero and we have not edited this previously
    gridPoints = ec_bottom_gridPoints
)



# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell%20Normal%20Junction.md
# ================================================== #
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ------- Notes -------- #
# rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773
# rGridStuff$pec = 737 -> R = 737 -> first 737 / 773 points are on EC
# ================================================== #
first_nj_cell <- last_endo_cell + 1
last_nj_cell <- rows_in_r
nj_top_gridPoints = expand.grid(50, seq(first_nj_cell, last_nj_cell)) 
nj_bottom_gridPoints = expand.grid(51, seq(first_nj_cell, last_nj_cell)) 

# eq2. Kp_gx * [P(r, z) - P(r, zg)] / dz - Kp_intima * [P(r, zi) - P(r, z)] / dz = 0
# eq2 @ part 1 --> (Kp_gx - kp_intima) / dz * P(r, z) - (Kp_gx * P(r, zg)) / dz : P(r, zg) = value @ im1j
# eq2 @ part 2 --> - (Kp_intima * P(r, zi)) / dz
PRESSURE %<>% map_equations_to_matrix(
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
    ,gridPoints = nj_top_gridPoints
)


# eq1. D(P, z)_nj2 + a_i * [P(r, zg) - P(r, zi) - S_nj * (PI(r, zg) - PI(r, zi))] = 0
# eq2. Kp_gx * [P(r, z) - P(r, zg)] / dz - Kp_intima * [P(r, zi) - P(r, z)] / dz = 0
# eq1 + eq2 @ part 1 --> D(P, z)_nj2 + (Kp_gx - kp_intima) / dz * P(r, z) + - P(r, zi) * a_i - (Kp_intima * P(r, zi)) / dz
# eq1 + eq2 @ part 2 --> a_i * P(r, zg) - (Kp_gx * P(r, zg)) / dz 
PRESSURE %<>% map_equations_to_matrix(
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
    ,gridPoints = nj_bottom_gridPoints
)

# i = dz
# j = dr 
