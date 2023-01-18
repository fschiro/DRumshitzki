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
TRACKER <- rep('P', length(PRESSURE@x)) %>% c(rep('C', length(CONCENTRATION@x))) %>% data.frame(label = .)
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

DEBUG: 
1. Large values found in matrix could be messing things up: 
    https://stackoverflow.com/questions/74971430/qr-factorization-in-r-not-giving-correct-answer-with-large-sparse-matrix



qr_decomp <- qr(PRESSURE_MAT, LAPACK = TRUE, tol = 1e-10)
PRESSURE <- qr.coef(qr_decomp, -PRESSURE_BV)

PRESSURE <- qr.solve(PRESSURE_MAT, PRESSURE_BV, tol = 1e-10) # or equivalently :
(PRESSURE_MAT %*% PRESSURE + PRESSURE_BV) %>% norm()
((PRESSURE_MAT %*% PRESSURE) + PRESSURE_BV) %>% norm

PRESSURE <- solve(qr(PRESSURE_MAT, LAPACK = TRUE), -PRESSURE_BV)

qrR(PRESSURE_MAT, )

qr2rankMatrix(qr_decomp) # 3079
##-- Solve linear equation system  H %*% x = y :
hilbert <- function(n) { i <- 1:n; 1 / outer(i - 1, i, `+`) }
h9 <- hilbert(9); h9
qr(h9)$rank   
qrh9 <- qr(h9, tol = 1e-10)
y <- 1:9/10
x <- qr.solve(h9, y, tol = 1e-10) # or equivalently :
x <- qr.coef(qrh9, y) #-- is == but much better than
                      #-- solve(h9) %*% y
h9 %*% x              # = y


a <- matrix(rnorm(9),ncol=3)
decomp <- qr(a)
y <- rnorm(3)
x <- qr.coef(decomp,y)
a %*% x - y
(a %*% x - y) %>% norm

cef_qr <- qr.solve(X, y)

Qmat <- qr.Q(QRmat)
Rmat <- qr.R(QRmat)
as.vector(backsolve(Rmat, crossprod(Qmat, y)))
# ======================================================== #
# Build concentration matrix (About 10 seconds on slow computer)
# ======================================================== #

file.path('build_concentration_matrix.r') %>% source
qr_decomp <- qr(CONC_MAT, LAPACK = TRUE)
CONCENTRATION <- qr.coef(qr_decomp, CONC_BV)


# ======================================================== #
# check and record output
# ======================================================== #
label = "t0"
TRACKER <- CONCENTRATION@x %>% c(PRESSURE@x) %>% data.frame(new = .) %>% dplyr::rename(!!label := new) %>% cbind(TRACKER)

if(any(!is.finite(TRACKER$t1))) {
	"time-step 0" %>% sprintf("ERROR: Non-finite values entered in state-vectors @ %s", .) %>% stop()
}

# ======================================================== #
# Fixed-Point iteration 
# ======================================================== #
Ck_original <- CONCENTRATION -> Ck
Ck <- CONCENTRATION + .0001 * ( CONC_MAT %*% Ck + CONC_BV )
norm_ <- (Ck - Ck_original) %>% norm
while(norm_ > .001 & is.finite(norm_)){
    norm_ %>% print
    Ck <- C0 + .0001 * ( CONC_MAT %*% Ck + CONC_BV )
    norm_ <- (Ck - Ck_original) %>% norm
    Ck_original <- Ck
}
norm_ %>% print

# ======================================================== #
# DEV 
# ======================================================== #






# visualize matrix -------------------
file.path(this_path, 'results', 'residual_plot.jpg') %>% jpeg()
print(image(PRESSURE_MAT, main = "image(PRESSURE_MAT)"))
dev.off()
# -------------------------------- end

