# ============================================================== #
# Variable assignments
# ============================================================== #

# r-grid spacing variables

alpha1 = 2.0 
alpha2 = 1.8;
alpha3 = 0.94;
alpha4 = 20;

# z-grid spacing variables

delta = 2.0;
beta = 1.6;
gamma = 10.0;

# domain dimensions

rfstar <- 0.8 * 1e-6; # finestral pore radius
Lgstar <- 200 * 1e-9; # Glycocalx region thickness
Lmstar <- 141 * 1e-6; # Media region thickness
Listar <- 200 * 1e-9; # Intima region thickness
rh = 15.0125; # Nondimensional length of r-domain including junction
xci = 15.0; # Nondimensional radius of endothelial cell
dR = 0.025; # Nondimensional width of normal junction

# viscosity 

mu = 7.2e-4; # viscosity of water

# osmotic reflection coeffs

sigma_EC <- 1.0  # osmotic reflection coeff of EC (Since it does not allow any albumin through)
sigma_nj <- 0.17 # osmotic reflection coeff of NJ

# Hydraulic conductivity

Lpm <- 5.6235 * 1e-12 # Hydraulic conductivity of media from Tieuvi
Lp_nj <- 5.5 * 1e-9 # Hydraulic conductivity of normal junction from Tieuvi's 20mmHg data
Lpe <- 6.3228 * 1e-12 # Intrinsic hydraluic conductivity of endothelium from 20 mmHg 
per <- 0  # percentage of AQPs contributing to Lp_EC
Lp_ec <-  per * Lpe / 100;

# Darcy permeability

Kpm <- Lpm * mu * Lmstar # Darcy permeability (Media)
Kpg <- 4.08 * 1e-18 # Darcy permeability [m]^2 (GX) (Source: Shripad Table1 * 10^-4)
Kpi <- 2.20 * 1e-16 # Darcy permeability [m]^2 (intima) (Source: Shripad Table1 * 10^-4)

# coefficients for shripad equation 6
# https://github.com/fschiro/DRumshitzki/blob/main/docs/Endothelial%20Cell.md
xi_g_ec <- (mu^2 * Lpe * Lgstar) / Kpg^2 
xi_i_ec <- (mu^2 * Lpe * Listar) / Kpi^2 
xi_nj <- (mu^2 * Lp_nj * Listar) / Kpi^2 

h_i <- Listar / rfstar # Ratio - region-thickness / finestral pore readius
h_m <- Lmstar / rfstar # Ratio - region-thickness / finestral pore readius
h_g <- Lgstar / rfstar # Ratio - region-thickness / finestral pore readius
h_ec <- 0 # really just a placeholder for this ratio at the endothelial cell 


# for endothelial make these correct 
a_gx = 1
a_intima = 1
kp_gx = 1
kp_intima = 1

# ============================================================== #
# Creating helpful math variables used in matrix creation
# ============================================================== #

# ======================================================== #
# Build grid
# ======================================================== #



# EC r in [0, R]
# Normal-Junction r in (R, end]
# Finestra r in [0, 1]
# Non-Finestra r in (1, end]
# R = max_ec = 737 -> first 737 / 773 points are on EC

# RGrid -> [Finestra, IEL1, IEL2, Junction]
# ZGrid -> [Glycocalyx, EC-NJ-cell1, EC-NJ-cell2, Intima, media]

# ------- R-direction ------- #
rGridStuff <- rgrid_multiplenew(alpha1, alpha2, alpha3, alpha4)
    # names(rGridStuff) # [1] "r"   "v"   "e1"  "e2"  "e3"  "e4"  "pec" "h"   "a" 
        # r <- grid points in "r" direction excluding end points
        # v <- grid points in fenestral hole
        # e1 <- number of elements in fenestra
        # e2 <- number of elements in 1st part of IEL 
        # e3 <- number of elements in 2nd part of IEL
        # e4 <- number of elements in junction
        # pec <- (integer): number of grid-points on endothelial cell (pec = 737)
        # h <- (array): grid spacings in "r" direction
        # a <- (array): node positions in "r" direction

# ------- Z-direction ------- #
glycoGrid <- zggrid(delta);
# Formation of grid in "z" direction (intima region) using zigrid.m
intimaGrid <- zigrid_new(beta);
# Formation of grid in "z" direction (media region) using zmgrid.m
mediaGrid <- zmgrid_new(gamma);



# ======================================================== #
#       r-grid variables 
#
# EC r in [0, R]
# Normal-Junction r in (R, end]
# Finestra r in [0, 1]
# Non-Finestra r in (1, end]
# ======================================================== #
# Important Variables:
# -- dr_forward & dr_backward 
#        A row-vector of delta-r values
#        repeat the last point because we lose 1 on calc
# 
# -- r
#        real values of r \in [0, 15.125]
#   
# -- r_inverse
#       1 / r
#
# -- rows_in_r
#        (constant) number of r-grid points
#
# -- first_non_finestra_cell, last_non_finestra_cell, last_finestra_cell, last_endo_cell
#         (constant) grid_points of boundaries in R
# ======================================================== #



r <- rGridStuff$a
r_inverse <- 1 / r
dr = r[2:length(r)] - r[1:(length(r) - 1)]
dr_forward <- c(dr, dr[length(dr)]) # adding extra point for distance to boundary
dr_backward <- c(dr[1], dr) # adding extra point for distance to boundary

rows_in_r <- length(r)

max_r <- length(r) # max_r = 773
max_ec <- rGridStuff$pec # max_ec = 737
# r = 1 @ 89 -> finestra \in r[0, 89]
max_finestra <- which(abs( (1 - r) / r) == min(abs( (1 - r) / r))) # max_finestra = 89

first_non_finestra_cell <- max_finestra + 1
last_non_finestra_cell = rows_in_r
last_finestra_cell <- max_finestra
last_endo_cell = max_ec



# ======================================================== #
#       Z-grid variables 
#
# Glycocalyx -> EC1 + EC2-> Intima -> media
# ======================================================== #
# Important Variables:
# -- dz_up & dz_down 
#        A column of delta-z values
# -- dz2_up & dz2_down
#        Difference between point z[i] - z[i-2]
# 
# -- dzu & dzd
#        Matrix of delta-z values
#        repeat dz_up & dz_down for every R-grid point
#
# -- rows_in_z
#        (constant) number of z-grid points
#        
# ======================================================== #

z_g <- glycoGrid$zg
dz_g <- z_g[2:length(z_g)] - z_g[1:(length(z_g) - 1)]
dz_g2 <- z_g[3:length(z_g)] - z_g[1:(length(z_g) - 2)]
dz_g_forward <- c(dz_g, dz_g[length(dz_g)]) # distance point 1 to boundary = distance point 1 to point 2
dz_g_backward <- c(dz_g[1], dz_g) # distance point 1 to boundary = distance point 1 to point 2
dz_g2_forward <- c(dz_g2, rep(dz_g2[length(dz_g2)], 2)) # distance point 1 to boundary = distance point 1 to point 2
dz_g2_backward <- c(rep(dz_g2[1], 2), dz_g2) # distance point 1 to boundary = distance point 1 to point 2


z_i <- intimaGrid$zi
dz_i <- z_i[2:length(z_i)] - z_i[1:(length(z_i) - 1)]
dz_i2 <- z_i[3:length(z_i)] - z_i[1:(length(z_i) - 2)]
dz_i_forward <- c(dz_i, dz_i[length(dz_i)])
dz_i_backward <- c(dz_i[1], dz_i) 
dz_i2_forward <- c(dz_i2, rep(dz_i2[length(dz_i2)], 2))
dz_i2_backward <- c(rep(dz_i2[1], 2), dz_i2) 


z_m <- mediaGrid$zm
dz_m <- z_m[2:length(z_m)] - z_m[1:(length(z_m) - 1)]
dz_m2 <- z_m[3:length(z_m)] - z_m[1:(length(z_m) - 2)]
dz_m_forward <- c(dz_m, dz_m[length(dz_m)])
dz_m_backward <- c(dz_m[1], dz_m) 
dz_m2_forward <- c(dz_m2, rep(dz_m2[length(dz_m2)], 2))
dz_m2_backward <- c(rep(dz_m2[1], 2), dz_m2) 

dz_up <- dz_g_backward %>% c(., .[length(.)],  dz_i_backward[1], dz_i_backward, dz_m_backward) # i - 1
dz_down <- dz_g_forward %>% c(., .[length(.)], dz_i_forward[1], dz_i_forward, dz_m_forward) # i + 1
dz2_up <- dz_g2_backward %>% c(., .[length(.)],  dz_i2_backward[1], dz_i2_backward, dz_m2_backward) # i - 2
dz2_down <- dz_g2_forward %>% c(., .[length(.)], dz_i2_forward[1], dz_i2_forward, dz_m2_forward) # i + 2

dzu <- dz_up %>% lapply(function(i) rep(i, rows_in_r)) %>% unlist
dzd <- dz_down %>% lapply(function(i) rep(i, rows_in_r)) %>% unlist
dz2u <- dz2_up %>% lapply(function(i) rep(i, rows_in_r)) %>% unlist
dz2d <- dz2_down %>% lapply(function(i) rep(i, rows_in_r)) %>% unlist

rows_in_z <- (length(z_i) + length(z_g) + length(z_m) + 2) # 2 for endothelial cells



# ======================================================== #
#       H variables 
# ======================================================== #
# Important Variables:
# -- H, H_SQR 
#        Matrices which has H-value for every grid-point
# 
# -- H_column
#        1 column of H for the values in Z
# ======================================================== #


H = rep(
        rep(h_g, rows_in_r),
        length(z_g)
    )
H %<>% c(., rep(h_ec, 2 * rows_in_r) ) # add endothelial h
H %<>% c(., 
    rep(
        rep(h_i, rows_in_r),
        length(z_i)
    )
)
H %<>% c(., 
    rep(
        rep(h_m, rows_in_r),
        length(z_m)
    )
)

H_SQR = H^2
H_column <- c(
    rep(h_g, length(z_g)),
    rep(h_ec, 2),
    rep(h_i, length(z_i)),
    rep(h_m, length(z_m))
)






Kp <- rep(
        rep(Kpg, rows_in_r),
        length(z_g) + 1
    )
Kp %<>% c(., 
    rep(
        rep(Kpi, rows_in_r),
        length(z_i) + 1
    )
)
Kp %<>% c(., 
    rep(
        rep(Kpm, rows_in_r),
        length(z_m)
    )
)


# ================================================== #
# Zero matrix for overwriting 
# ================================================== #
zeros = rep(0, rows_in_r * rows_in_z)




