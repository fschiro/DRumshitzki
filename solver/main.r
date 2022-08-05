# ======================================================== #
# Load dependencies
# ======================================================== #

library(magrittr)

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
# Todo:
# 1. Load PRESSURE_MATRIX and invert!
# 2. Create framework for concentration matrix!
# ======================================================== #





# ======================================================== #
# Solve with QR factorization 
# Q = orthogonal
# R = upper triangular
# Ax = B 
# QRx = B
# Rx = Q^T B
# solve with back substitution
# ======================================================== #
#https://www.r-bloggers.com/2015/07/dont-invert-that-matrix-why-and-how/
# QR decomposition is included in base R. You use the function qr once to create a decomposition, then use qr.coef to solve for x repeatedly using new b’s.
qr_decomp = qr(PRESSURE_MAT, LAPACK = TRUE)
xhat_qr = qr.coef(qr_decomp, PRESSURE_BV)




# ======================================================== #
# DEV 
# ======================================================== #

# visualize matrix -------------------
file.path(this_path, 'results', 'residual_plot.jpg') %>% jpeg()
print(image(PRESSURE_MAT, main = "image(PRESSURE_MAT)"))
dev.off()
# -------------------------------- end


PRESSURE_MAT_INV <- solve(PRESSURE_MAT)
test <- solve(PRESSURE_MAT, PRESSURE_BV) 
test <- solve(PRESSURE_MAT, PRESSURE_BV, sparse = TRUE)
# out of memory
# Error in .solve.dgC(a, as(b, "denseMatrix"), tol = tol, sparse = sparse) : cs_lu(A) failed: near-singular A (or out of memory)
https://www.r-bloggers.com/2015/07/dont-invert-that-matrix-why-and-how/
https://cran.r-project.org/web/packages/sparseinv/sparseinv.pdf
https://cran.r-project.org/web/packages/Matrix/Matrix.pdf
https://cran.r-project.org/web/packages/Matrix/vignettes/Intro2Matrix.pdf
"Also there is no direct support for sparse matrices in R although Koenker and Ng (2003) have developed
the SparseM package for sparse matrices based on SparseKit."

PRESSURE_MAT 
173925 x 173925 sparse Matrix of class "dgCMatrix"
# note it is already sparse
#print(image(PRESSURE_MAT, main = "image(PRESSURE_MAT)"))


ddenseMatrix
dgCMatrix
dgeMatrix
dpoMatrix
dsCMatrix
dspMatrix
dtCMatrix
dsyMatrix
