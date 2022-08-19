# ======================================================== #
# Overview: 
# Create matrix which, when multiplied by PRESSURE state vector, 
#	produces DFDZ at every gridpoint
# ======================================================== #


# ======================================================== #
# Create initial sparse-matrices
# ======================================================== #
DFDZ <- Matrix(nrow = gridDimension, ncol = gridDimension, data = 0, sparse = TRUE)

# ================================================== #
# Main equations over all points
# ================================================== #
# h^2 * (D2(P, r) + 1/r * D(P, r) ) + D2(P, z) = 0

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = gamma_5, 
    ip1j = gamma_6, 
    im1j = gamma_4,     
    gridPoints = NULL # Null sets to all points on interior
)

# ================================================== #
# Top, bottom boundaries
# ================================================== #
# ------- Equations ------- #
# Pg = 1 @ z = GX top
# Pm = 0 @ z = Media bottom
# ================================================== #

gridPoints_top = expand.grid(1, seq(rows_in_r))
gridPoints_bot = expand.grid(rows_in_z, seq(rows_in_r))

# top
DFDZ %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = omega_2, 
    ip1j = omega_3, 
    im1j = omega_1,      
    gridPoints = gridPoints_top
)

DFDZ %<>% map_equations_to_b_vector(
    rows_in_z, rows_in_r,
    ij = omega_5, 
    ip1j = omega_6, 
    im1j = omega_4,      
    gridPoints = gridPoints_bot
)

# bottom not needed

if(any(!is.finite(DFDZ@x))) {
	"Interior or outer boundaries" %>% sprintf("ERROR: Non-finite values entered in DFDZ matrix @ %s", .) %>% stop()
}

# ================================================== #
# Intima-Media boundary - Finestra hole
# Docs: https://github.com/fschiro/DRumshitzki/blob/main/docs/Intima-Media%20Finestra.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction
# ================================================== #

intima_bottom_gridPoints <- expand.grid(136, seq(last_finestra_cell))
media_top_gridPoints <- expand.grid(137, seq(last_finestra_cell)) 

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_5
    ,im1j = omega_4
    ,ip1j = omega_6   
    ,gridPoints = intima_bottom_gridPoints
)

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_2
    ,im1j = omega_1
    ,ip1j = omega_3
    ,gridPoints = media_top_gridPoints
)

if(any(!is.finite(DFDZ@x))) {
	"Intima-Media Finestra" %>% sprintf("ERROR: Non-finite values entered in DFDZ matrix @ %s", .) %>% stop()
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


DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_5
    ,im1j = omega_4
    ,ip1j = omega_6   
    ,gridPoints = not_finestra_intima_bottom_gridPoints
)

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_2
    ,im1j = omega_1
    ,ip1j = omega_3
    ,gridPoints = not_finestra_media_top_gridPoints
)


if(any(!is.finite(DFDZ@x))) {
	"Intima-Media Non-Finestra" %>% sprintf("ERROR: Non-finite values entered in DFDZ matrix @ %s", .) %>% stop()
}


# ================================================== #
# Endothelial Cells
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell.md
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_5
    ,im1j = omega_4
    ,ip1j = omega_6   
    ,gridPoints = ec1_gridPoints
)

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_2
    ,im1j = omega_1
    ,ip1j = omega_3
    ,gridPoints = ec2_gridPoints
)


if(any(!is.finite(DFDZ@x))) {
	"Endothelial Cell" %>% sprintf("ERROR: Non-finite values entered in DFDZ matrix @ %s", .) %>% stop()
}

# ================================================== #
# Endothelial Cells - normal junction (space between EC)
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell%20Normal%20Junction.md
# ================================================== #
# Question: Why no boundary vector changes?
# 	Answer: No components in r-direction on EC
#			All elements in grid
# ================================================== #
DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = omega_5
    ,im1j = omega_4
    ,ip1j = omega_6   
    ,gridPoints = nj1_gridPoints
)

DFDZ %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r
    ,ij = omega_2
    ,im1j = omega_1
    ,ip1j = omega_3
    ,gridPoints = nj2_gridPoints
)

if(any(!is.finite(DFDZ@x))) {
	"Endothelial Cell - Normal Junction" %>% sprintf("ERROR: Non-finite values entered in DFDZ matrix @ %s", .) %>% stop()
}

# i = dz
# j = dr 
