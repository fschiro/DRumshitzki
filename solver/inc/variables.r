# ============================================================== #
# Variable assignments
# ============================================================== #
common_length <- 'cm' # for converting all units to common length scale

# r-grid spacing variables

alpha1 = 2.0 
alpha2 = 1.8;
alpha3 = 0.94;
alpha4 = 20;

# z-grid spacing variables

delta = 2.0;
beta = 1.6;
gamma = 10.0;

# Pressure Lumin I believe is related to Listar
PL_star <- 40 # mmHg [Fig 3. Shripad] ## Lumin Pressure ### estimate 40 from fig 3. because Listar in Shripad code was 200nm and I believe they are related 
PL_star %<>% conv_unit(from = 'mm', to = common_length)
# domain dimensions
rfstar <- 0.8 * 1e-6; # uM ## finestral pore radius 
Lgstar <- 200 * 1e-9; # nM ## Glycocalx region thickness
Lmstar <- 141 * 1e-6; # uM ## Media region thickness
Listar <- 200 * 1e-9; # nM ## Intima region thickness
rfstar %<>% conv_unit(from = 'um', to = common_length)
Lgstar %<>% conv_unit(from = 'nm', to = common_length)
Lmstar %<>% conv_unit(from = 'um', to = common_length)
Listar %<>% conv_unit(from = 'nm', to = common_length)

# For concentration matrix EC 
PE_ec <- 12 * 1e-7;  # cM/s ## [Table 1 Shripad]
PE_nj <- 1.21 * 1e-3;  # cM/s ## [Table 1 Shripad]
PE_ec %<>% conv_unit(from = 'cm', to = common_length)
PE_nj %<>% conv_unit(from = 'cm', to = common_length)

# volume fraction of albumim per unit total volume of region j
gam_g <- .94 # table 1 Shripad
gam_i <- .94 # table 1 Shripad
gam_m <- .08 # table 1 Shripad


rh = 15.0125; # Nondimensional length of r-domain including junction
xci = 15.0; # Nondimensional radius of endothelial cell
dR = 0.025; # Nondimensional width of normal junction

# viscosity (I THINK THIS IS WRONG)

mu = 7.2e-4; # kg/m-s [Table1] ## viscosity of water 
mu <- mu * conv_unit(1, common_length, 'm') # kg/m-s -> kg / cm-s (multiplying because 1/m * m/cm = 1/cm)

# osmotic reflection coeffs

sigma_EC <- 1.0  # osmotic reflection coeff of EC (Since it does not allow any albumin through)
sigma_nj <- 0.17 # osmotic reflection coeff of NJ

# Hydraulic conductivity

Lpm <- 5.6235 * 1e-12 # Hydraulic conductivity of media from Tieuvi
Lp_nj <- 5.5 * 1e-9 # Hydraulic conductivity of normal junction from Tieuvi's 20mmHg data
Lpe <- 6.3228 * 1e-12 # Intrinsic hydraluic conductivity of endothelium from 20 mmHg 

# I multiplied by 10^-3 because maybe mm->m ? 
Lpm <- Lpm * 1e-3
Lp_nj <- Lp_nj * 1e-3
Lpe <- Lpe * 1e-3


per <- 0  # percentage of AQPs contributing to Lp_EC
Lp_ec <-  per * Lpe / 100; #[Shripad code]


Lp_nj <- 6.09 * 1e-5 # cm/sec mmHg [Table1] ## Hydraulic conductivity of normal junction from Tieuvi's 20mmHg data
Lp_ec <- 3.38 * 1e-8 # cm/sec mmHg [Table1]
Lp_nj %<>% conv_unit(from = 'cm', to = common_length)
Lp_ec %<>% conv_unit(from = 'cm', to = common_length)

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



fi <- 0.99
fg <- 0.99
fm <- 0.3

# diffusivity of albumim in region j
# I believe Dj = Dj*. In Glossery Dj = effective diffusivity of albumim in region j & in 2.3 first paragraph: "Dj* [is region j's] effective diffusivity"
dg <- 2.75* 1e-7 # cm^2 / s (Source: Shripad Table1)
di <- 3.76* 1e-7 # cm^2 / s (Source: Shripad Table1)
dm <- 1.296* 1e-8 # cm^2 / s (Source: Shripad Table1)
dg %<>% conv_unit(from = 'cm2', to = paste0(common_length, '2'))
di %<>% conv_unit(from = 'cm2', to = paste0(common_length, '2'))
dm %<>% conv_unit(from = 'cm2', to = paste0(common_length, '2'))

# volume fraction of albumim per unit total volume region j
gg <- 0.94
gi <- 0.94
gm <- 0.08


dg_over_lg <- rep(rep(dg / Lgstar, rows_in_r), rows_in_z)
di_over_li <- rep(rep(di / Listar, rows_in_r), rows_in_z)
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
# dev: remove r[0] from R-vector and consider this point to be boundary to avoid 1/0 = 0
dr_backward = r[2:length(r)] - r[1:(length(r) - 1)]
dr_forward = abs( r[2:(length(r) - 1)] - r[3:length(r)] )
dr_forward %<>% c(., .[length(.)])
r <- r[2:length(r)]
r_inverse <- 1 / r

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
dz_i <- z_i[2:length(z_i)] - z_i[1:(length(z_i) - 1)]    # [(2-1), (3-2), ..., (N - N-1)]
dz_i2 <- z_i[3:length(z_i)] - z_i[1:(length(z_i) - 2)]
dz_i_forward <- c(dz_i, dz_i[length(dz_i)])				# [(2-1), (3-2), ..., (N - N-1), (N - N-1)]
dz_i2_forward <- c(dz_i2, rep(dz_i2[length(dz_i2)], 2))
dz_i_backward <- c(dz_i[1], dz_i) 		# backward is forward shifted over by 1
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



# dimension of grid
gridDimension <- rows_in_z * rows_in_r

# =========================================== #
# Endothelial cell gridpoints define 
# Define here bc we use often
# =========================================== #
ec1_z <- length(z_g) + 1
ec2_z <- ec1_z + 1

ec1_gridPoints = expand.grid(ec1_z, seq(last_endo_cell)) 
ec2_gridPoints = expand.grid(ec2_z, seq(last_endo_cell))

first_nj_cell <- last_endo_cell + 1
last_nj_cell <- rows_in_r

nj1_gridPoints = expand.grid(ec1_z, seq(first_nj_cell, last_nj_cell)) 
nj2_gridPoints = expand.grid(ec2_z, seq(first_nj_cell, last_nj_cell))

index_ec1 <- ec1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r)	
index_ec2 <- ec2_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r)	

index_nj1 <- nj1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r)	
index_nj2 <- nj2_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r)	

index_intima_from_ec1 <- ec1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = 2)	
index_intima_from_ec2 <- ec1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = 1)	

index_gx_from_ec1 <- ec1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = -1)	
index_gx_from_ec2 <- ec2_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = -2)

index_intima_from_nj1 <- nj1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = 2)	
index_intima_from_nj2 <- nj1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = 1)	

index_gx_from_nj1 <- nj1_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = -1)	
index_gx_from_nj2 <- nj2_gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = -2)

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
ones = rep(1, rows_in_r * rows_in_z)


# ================================================== #
# iota_coef for concentration matrix 
# Source: https://github.com/fschiro/DRumshitzki/blob/main/docs/Albumin%20Transport%20Model/Interior%20Grid%20Points.md
# ================================================== #
# iota_coef = (fj x Pl* x Kpj) / ( gam_j x Dj* x Mu) 
iota_coef = rep(
        rep(
			( fg * Kpg ) / (gam_g * dg), 
			rows_in_r
		), length(z_g)
    )
iota_coef %<>% c(., rep(0, 2 * rows_in_r) ) # ec not needed
iota_coef %<>% c(., 
    rep(
        rep(
			( fi * Kpi ) / (gam_i * di), 
			rows_in_r
		), length(z_i)
    )
)
iota_coef %<>% c(., 
    rep(
        rep(
			( fm * Kpg ) / (gam_m * dm), 
			rows_in_r
		), length(z_m)
    )
)
iota_coef <- (PL_star / mu) * iota_coef


# ================================================== #
# Run some tests & quit program if tests fail 
# ================================================== #
finiteTest(r_inverse, 'r_inverse')
finiteTest(dr_forward, 'dr_forward')
finiteTest(dr_backward, 'dr_backward')
finiteTest(dzd, 'dzd')
finiteTest(dzu, 'dzu')
finiteTest(dzu, 'iota_coef')



