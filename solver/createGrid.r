# ======================================================== #
# Overview
# ======================================================== #



# Apply equations to matrix and B vector in grid space
# This should be re-created so matrix equations defined in user-input 

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
# Matrix-space conversion = handled automatically
#   These functions return -1 when out point out-of-grid
#   All points in grid are not boundary (they may be adjacent to boundary)



# ======================================================== #
# Framework
# ======================================================== #



# Define matrix equations
# Equations automatically applied in correct positions in matrix
# If you re-apply a point, it gets overwritten
# Thus boundary points easy to apply
# Non-boundary equations:
#   Write equations for ij, ijp1, ijm1, ip1j, im1j
#   Apply equations to all points in matrix
#   points such as ijp1 which are not in matrix detected and ignored automatically
# Boundary equations: 
#   Write equations for ij, ijp1, ijm1, ip1j, im1j for the boundary points only
#   points such as ijp1 which are not in matrix detected and ignored automatically
#     These points will be applied to boundary automatically



dimA <- rows_in_z * rows_in_r
A <- Matrix(nrow = dimA, ncol = dimA, data = 0, sparse = TRUE)
B <- Matrix(nrow = dimA, ncol = 1, data = 0, sparse = TRUE)



# ================================================== #
# Main equations over all points
# ================================================== #
# ------- Equations ------- #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0
# ------- Discritization ------- #
# D2(P, r) = 2 / (Hf * (Hb + Hf)) * P(r + Hf, z) - 2 / (Hb * Hf) * P(r, z)  + 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)
# D(P, r) = Hb / (Hf * (Hb + Hf)) * P(r + Hf, z) - (Hb - Hf) / (Hb * Hf) * P(r, z)  + Hf / (Hb * (Hb + Hf)) * P(r - Hb, z)
# D2(P, z) = 2 / (Hd * (Hd + Hu)) * P(r, z + Hd) - 2 / (Hd * Hu) * P(r, z)  + 2 / (Hu * (Hd + Hu)) * P(r, z - Hu)
# ------- Matrix ------- #
# P(r + Hf, z) = h^2 * ( 2 / (Hf * (Hb + Hf)) + [1 / r] * Hb / (Hf * (Hb + Hf)) )
# P(r - Hb, z) = h^2 * ( 2 / (Hb * (Hb + Hf)) + [1 / r] * Hf / (Hb * (Hb + Hf)) )
# P(r, z) = h^2 * (- 2 / (Hb * Hf) - [1 / r] * (Hb - Hf) / (Hb * Hf) ) - 2 / (Hd * Hu)
# P(r, z + Hd) = 2 / (Hd * (Hd + Hu))
# P(r, z - Hu) = 2 / (Hu * (Hd + Hu)
# ------- Notes ------- #
# rows_in_r is the number of r points should probably be renamed 'columns_in_r'
# ================================================== #


A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = d2pdr_ij + dpdr_ij + d2pdz_ij, 
    ip1j = d2pdz_ip1j, 
    im1j = d2pdz_im1j, 
    ijp1 = d2pdr_ijp1 + dpdr_ijp1, 
    ijm1 = d2pdr_ijm1 + dpdr_ijm1, 
    gridPoints = NULL
)



# ================================================== #
# Left + right boundaries
# ================================================== #
# ------- Equations ------- #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0
# axisymmetric -> P(0, z) = P(r_max, z)
# D(P, r) = 0
# ------- Discritization ------- #
# D2(P, r) = 2 / (Hf * (Hb + Hf)) * P(r + Hf, z) - 2 / (Hb * Hf) * P(r, z)  + 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)
# D(P, r) = 0
# D2(P, z) = 2 / (Hd * (Hd + Hu)) * P(r, z + Hd) - 2 / (Hd * Hu) * P(r, z)  + 2 / (Hu * (Hd + Hu)) * P(r, z - Hu)
# ------- Matrix ------- #
# [Need-Apply] P(r + Hf, z) = h^2 * ( 2 / (Hf * (Hb + Hf)) + 0 )
# [Need-Apply] P(r - Hb, z) = h^2 * ( 2 / (Hb * (Hb + Hf)) + 0 )
# [Need-Apply] P(r, z) = h^2 * (- 2 / (Hb * Hf) + 0) - 2 / (Hd * Hu)
# [No Change] P(r, z + Hd) = 2 / (Hd * (Hd + Hu))
# [No Change] P(r, z - Hu) = 2 / (Hu * (Hd + Hu)
# ------- Notes ------- #
# Overwrite ij in A because D(P, r) = 0
# Overwrite ijm1 @ left gridpoints because D(P, r) = 0
# Overwrite ijp1 @ right gridpoints because D(P, r) = 0
# Also send to B-vector for im1j
# ================================================== #

# 1. i, j = [row, column] of grid space -> dr = dj, dz = di
# 2. we input vectors with 1 value for each point in entire grid-space
# 3. We input the gridpoints which we are interested in changing
# 4. function will grab the correct points from vector and matrix given input gridpoints


gridPoints_left = expand.grid(seq(rows_in_z), 1)
gridPoints_right = expand.grid(seq(rows_in_z), rows_in_r)

# apply to matrices
A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = d2pdr_ij + d2pdz_ij, 
    ip1j = NULL, # don't need - did it last section and we don't overwrite if NULL
    im1j = NULL, # don't need - did it last section and we don't overwrite if NULL
    ijp1 = NULL,
    ijm1 = d2pdr_ijm1,
    gridPoints = gridPoints_left
)
B %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = NULL, 
    ijm1 = d2pdr_ijm1, 
    gridPoints = gridPoints_left
)

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = d2pdr_ij + d2pdz_ij, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = d2pdr_ijp1, 
    ijm1 = NULL, 
    gridPoints = gridPoints_right
)
B %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r, 
    ij = NULL, 
    ip1j = NULL, 
    im1j = NULL, 
    ijp1 = d2pdr_ijp1, 
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
# ------- Discritization ------- #
# D2(P, r) = 2 / (Hf * (Hb + Hf)) * P(r + Hf, z) - 2 / (Hb * Hf) * P(r, z)  + 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)
# D(P, r) = Hb / (Hf * (Hb + Hf)) * P(r + Hf, z) - (Hb - Hf) / (Hb * Hf) * P(r, z)  + Hf / (Hb * (Hb + Hf)) * P(r - Hb, z)
# D2(P, z) = 2 / (Hd * (Hd + Hu)) * P(r, z + Hd) - 2 / (Hd * Hu) * P(r, z)  + 2 / (Hu * (Hd + Hu)) * P(r, z - Hu)
# ------- Matrix ------- #
# P(r + Hf, z) = h^2 * ( 2 / (Hf * (Hb + Hf)) + [1 / r] * Hb / (Hf * (Hb + Hf)) )
# P(r - Hb, z) = h^2 * ( 2 / (Hb * (Hb + Hf)) + [1 / r] * Hf / (Hb * (Hb + Hf)) )
# P(r, z) = h^2 * (- 2 / (Hb * Hf) - [1 / r] * (Hb - Hf) / (Hb * Hf) ) - 2 / (Hd * Hu)
# P(r, z + Hd) = 2 / (Hd * (Hd + Hu))
# P(r, z - Hu) = 2 / (Hu * (Hd + Hu)
# ------- Notes -------- #
# Nothing is changing in matrix A for top + bottom boundaries. 
# im1j = 1 implies that B = 1 for top_gridpoints
# ip1j = 0 implies B = 0 for bottom gridpoints
# ================================================== #

gridPoints_top = expand.grid(1, seq(rows_in_r))
gridPoints_bot = expand.grid(rows_in_z, seq(rows_in_r))

B %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = NULL, 
    ip1j = NULL, 
    im1j = rep(1, rows_in_r * rows_in_z),  
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_top
)
# dont really need to do this since it is zero but for completion of framework we will
B %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r, 
    ij = NULL, 
    ip1j = rep(0, rows_in_r * rows_in_z),
    im1j = NULL, 
    ijp1 = NULL, 
    ijm1 = NULL, 
    gridPoints = gridPoints_bot
)


# ================================================== #
# Endothelial Cells
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell.md
# ================================================== #

ec_top_gridPoints = expand.grid(50, seq(last_endo_cell)) 
ec_bottom_gridPoints = expand.grid(51, seq(last_endo_cell))

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_6,
    ip1j = zeros,
    im1j = omega_5 + xi_g_ec,
    ip2j = -xi_g_ec,
    im2j = omega_4,
    ijp1 = zeros, 
    ijm1 = zeros,
    ijp2 = zeros,
    ijm2 = zeros,
    gridPoints = ec_top_gridPoints
)

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_3,
    ip1j = omega_2 - xi_i_ec,
    im1j = zeros,
    ip2j = omega_1,
    im2j = xi_i_ec,
    ijp1 = zeros, 
    ijm1 = zeros,
    ijp2 = zeros,
    ijm2 = zeros,
    gridPoints = ec_bottom_gridPoints
)



# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell%20Normal%20Junction.md
# ================================================== #
# ------- Notes -------- #
# rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773
# rGridStuff$pec = 737 -> R = 737 -> first 737 / 773 points are on EC
# No B-Vector 
# ================================================== #
first_nj_cell <- last_endo_cell + 1
last_nj_cell <- rows_in_r
nj_top_gridPoints = expand.grid(50, seq(first_nj_cell, last_nj_cell)) 
nj_bottom_gridPoints = expand.grid(51, seq(first_nj_cell, last_nj_cell)) 

# eq2. Kp_gx * [P(r, z) - P(r, zg)] / dz - Kp_intima * [P(r, zi) - P(r, z)] / dz = 0
# eq2 @ part 1 --> (Kp_gx - kp_intima) / dz * P(r, z) - (Kp_gx * P(r, zg)) / dz : P(r, zg) = value @ im1j
# eq2 @ part 2 --> - (Kp_intima * P(r, zi)) / dz
A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = -Kpg * omega_6,
    im1j = -Kpg * omega_5,
    im2j = -Kpg * omega_4,
    ip1j = Kpg * omega_3,
    ip2j = Kpg * omega_2,
    ip3j = Kpg * omega_1,
    ijm1 = zeros,
    ijm2 = zeros,
    ijp1 = zeros, 
    ijp2 = zeros,
    gridPoints = nj_top_gridPoints
)


# eq1. D(P, z)_nj2 + a_i * [P(r, zg) - P(r, zi) - S_nj * (PI(r, zg) - PI(r, zi))] = 0
# eq2. Kp_gx * [P(r, z) - P(r, zg)] / dz - Kp_intima * [P(r, zi) - P(r, z)] / dz = 0
# eq1 + eq2 @ part 1 --> D(P, z)_nj2 + (Kp_gx - kp_intima) / dz * P(r, z) + - P(r, zi) * a_i - (Kp_intima * P(r, zi)) / dz
# eq1 + eq2 @ part 2 --> a_i * P(r, zg) - (Kp_gx * P(r, zg)) / dz 
A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = zeros,
    ip1j = zeros,
    im1j = zeros,
    ip2j = zeros, # note use xi_nj
    im2j = zeros,
    im3j = zeros,
    ijp1 = zeros, 
    ijm1 = zeros,
    ijp2 = zeros,
    ijm2 = zeros,
    gridPoints = nj_bottom_gridPoints
)






# ============================================= # 
# Updating Albumim concentrations
# I'm unsure if index is correct maybe should just be the gridpoints 
# ============================================= #

# --------- endothelial cell ------------
index_ec_top <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_ec_bottom <- ec_bottom_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_intima <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = 2)) %>% do.call(rbind, .) %>% .[, 1]
index_gx <- ec_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = -1)) %>% do.call(rbind, .) %>% .[, 1]

# gx + intima for ec_top
B[ index_ec_top ] <- B[ index_ec_top ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]
# gx + intima for ec_bot
B[ index_ec_bottom ] <- B[ index_ec_bottom ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]

# --------- Normal-Junction ------------
index_nj_top <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_nj_bottom <- nj_bottom_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .) 
index_intima <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = 2)) %>% do.call(rbind, .) %>% .[, 1]
index_gx <- nj_top_gridPoints %>% split(., seq(nrow(.))) %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = -1)) %>% do.call(rbind, .) %>% .[, 1]

# gx + intima for nj_top
B[ index_nj_top ] <- B[ index_nj_top ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]
# gx + intima for nj_bot
B[ index_nj_bottom ] <- B[ index_nj_bottom ] + sigma_ec * concentration_[ index_intima ] - sigma_ec * concentration_[ index_gx ]



# ================================================== #
# Intima-Media boundary - Finestra hole
# ================================================== #
# ------- Notes -------- #
# rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773
# rGridStuff$pec = 737 -> R = 737 -> first 737 / 773 points are on EC
# No B-Vector 
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

kpi_by_dz <- Kpi / dzu
kpm_by_dz <- Kpm / dzd

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij =   d2pdr_ij + dpdr_ij + d2pdz_ij + d2pdz_ip1j + kpi_by_dz, # d2pdz_ip1j bc EQ1
    ip1j = zeros, 
    im1j = d2pdz_im1j - kpi_by_dz, 
    ijp1 = d2pdr_ijp1 + dpdr_ijp1, 
    ijm1 = d2pdr_ijm1 + dpdr_ijm1, 
    gridPoints = intima_bottom_gridPoints
)

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij =   d2pdr_ij + dpdr_ij + d2pdz_ij + d2pdz_im1j + kpm_by_dz, # d2pdz_ip1j bc EQ1
    ip1j = d2pdz_ip1j - kpm_by_dz,
    im1j = zeros, 
    ijp1 = d2pdr_ijp1 + dpdr_ijp1, 
    ijm1 = d2pdr_ijm1 + dpdr_ijm1, 
    gridPoints = media_top_gridPoints
)



# ================================================== #
# Intima-Media boundary - Non-Finestra
# ================================================== #
# rGridStuff$a = 1 at point 89 thus finestra is first 89 points of 773
# rGridStuff$pec = 737 -> R = 737 -> first 737 / 773 points are on EC
# No B-Vector 
# ================================================== #


non_finestra_sequence_r = seq(first_non_finestra_cell, last_non_finestra_cell)
not_finestra_intima_bottom_gridPoints = expand.grid(136, non_finestra_sequence_r)
not_finestra_media_top_gridPoints = expand.grid(137, non_finestra_sequence_r) 


A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij =   d2pdr_ij + dpdr_ij + d2pdz_ij + d2pdz_im1j * dzu,
    ip1j = d2pdz_ip1j, 
    im1j = zeros, 
    ijp1 = d2pdr_ijp1 + dpdr_ijp1, 
    ijm1 = d2pdr_ijm1 + dpdr_ijm1, 
    gridPoints = not_finestra_intima_bottom_gridPoints
)

A %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij =   d2pdr_ij + dpdr_ij + d2pdz_ij + d2pdz_ip1j * dzd,
    ip1j = zeros,
    im1j = d2pdz_im1j, 
    ijp1 = d2pdr_ijp1 + dpdr_ijp1, 
    ijm1 = d2pdr_ijm1 + dpdr_ijm1, 
    gridPoints = not_finestra_media_top_gridPoints
)


# i = dz
# j = dr 
