# ======================================================== #
# Load dependencies
# ======================================================== #
# libraries and helpfull R functions 
source('inc/depend.r') 
# get shripad grid functions
file.path('inc', 'gridCreation', 'rGridMultipleNew.r') %>% source
file.path('inc', 'gridCreation', 'zggrid.r') %>% source
file.path('inc', 'gridCreation', 'zigrid_new.r') %>% source
file.path('inc', 'gridCreation', 'zmgrid_new.r') %>% source
# Matrix functions
file.path('inc', 'map_grid_matrix_fun_v3.r') %>% source
# parameters / variables
file.path('inc', 'variables.r') %>% source
file.path('inc', 'one_sided_FD.r') %>% source
file.path('inc', 'two_sided_FD_v2.r') %>% source
file.path('inc', 'dfdr.r') %>% source
file.path('inc', 'dfdz.r') %>% source
# Other functions
file.path('inc', 'update_albumim_fun.r') %>% source

# ======================================================== #
# Create initial state vectors
# ======================================================== #

PRESSURE <<- Matrix(nrow = gridDimension, data = 0, sparse = TRUE)
CONCENTRATION <<- Matrix(nrow = gridDimension, data = 0, sparse = TRUE)

# ======================================================== #
# Build pressure matrix (About 10 seconds on slow computer)
# ======================================================== #

file.path('build_pressure_matrix.r') %>% source
PRESSURE_BV %<>% pressure_bv_albumim_updater(CONCENTRATION)

# ======================================================== #
# Active dev below:
# Todo:
#    1. EQ 24 is concentration matrix with time element
#    2. Create EQ 24 in matrix form w and w/ time element (no time = eq14 = current conc_matrix)
#    3. Scheme: 
#           A. solve eq 24 -> get concentration
#           B. CYLCE[update pressure matrix -> solve pressure -> update concentration -> solve concentration t++]
#    3. Fix variable units (mm vs m, mm^2 vs m^2) 
#		Use function to convert, put function in depend.r
#    4. Rumschitzki two-sided difference scheme
# ======================================================== #




# ======================================================== #
# Solve with QR factorization 
# Q = orthogonal
# R = upper triangular
# Ax = B 
# QRx = B
# Rx = Q^T B
# R is upper triangular -> solve with back substitution 
# ======================================================== #
#https://www.r-bloggers.com/2015/07/dont-invert-that-matrix-why-and-how/
# QR decomposition is included in base R. You use the function qr once to create a decomposition, then use qr.coef to solve for x repeatedly using new b’s.
qr_decomp <- qr(PRESSURE_MAT, LAPACK = TRUE)
PRESSURE <- qr.coef(qr_decomp, PRESSURE_BV)

# ======================================================== #
# Build concentration matrix (About 10 seconds on slow computer)
# ======================================================== #

file.path('build_concentration_matrix.r') %>% source
qr_decomp <- qr(CONC_MAT, LAPACK = TRUE)
CONCENTRATION <- qr.coef(qr_decomp, CONC_BV)

# ======================================================== #
# DEV 
# ======================================================== #

# visualize matrix -------------------
file.path(this_path, 'results', 'residual_plot.jpg') %>% jpeg()
print(image(PRESSURE_MAT, main = "image(PRESSURE_MAT)"))
dev.off()
# -------------------------------- end

