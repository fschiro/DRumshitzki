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

# U*
dpdz = DPDZ %*% PRESSURE 
# W*
dpdr = DPDR %*% PRESSURE


rfstar
Lgstar
Lmstar
Listar
H, H_column, H_SQR
h_i <- Listar / rfstar # Ratio - region-thickness / finestral pore readius
h_m <- Lmstar / rfstar # Ratio - region-thickness / finestral pore readius
h_g <- Lgstar / rfstar # Ratio - region-thickness / finestral pore readius


