# ======================================================== #
# Overview: 
# Create matrix which, when multiplied by PRESSURE state vector, 
#	produces dpdr at every gridpoint
# ======================================================== #


# ======================================================== #
# Create initial sparse-matrices
# ======================================================== #

DPDR <- Matrix(nrow = gridDimension, ncol = gridDimension, data = 0, sparse = TRUE)

# ================================================== #
# Main equations over all points
# ================================================== #

DPDR %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = gamma_2,        
    ijp1 = gamma_3, 
    ijm1 = gamma_1, 
    gridPoints = NULL # Null sets to all points on interior
)

# ================================================== #
# Left + right boundaries
# ================================================== #
# ------- Equations ------- #
# D(P, r) = 0
# ================================================== #

gridPoints_left = expand.grid(seq(rows_in_z), 1)
gridPoints_right = expand.grid(seq(rows_in_z), rows_in_r)

# left
DPDR %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = zeros,     
    gridPoints = gridPoints_left
)

# Right
DPDR %<>% map_equations_to_matrix(
    rows_in_z, rows_in_r, 
    ij = zeros,             
    gridPoints = gridPoints_right
)


if(any(!is.finite(DPDR@x))) {
	"Interior or outer boundaries" %>% sprintf("ERROR: Non-finite values entered in DPDR matrix @ %s", .) %>% stop()
}

# i = dz
# j = dr 
