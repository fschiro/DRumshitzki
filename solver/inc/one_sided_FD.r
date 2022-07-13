# See https://github.com/fschiro/DRumshitzki/blob/main/docs/Discritization.md

# Note: Positive Z is down in matrix/grid
#       Grid[1, .] = z1
#       Grid[N, .] = zN

# d_/dz up-direction
omega_1 <- -1 * dzd / (dz2d * (dzd + dz2d))
omega_2 <- (dzd + dz2d) / (dzd * dz2d)
omega_3 <- -1 * (2 * dzd + dz2d) / (dz2d * (dzd + dz2d))

# d_/dz down-direction
omega_4 <- dzu / (dz2u * (dzu + dz2u))
omega_5 <- -1 * (dzu + dz2u) / (dzu * dz2u)
omega_6 <- (2 * dzu + dz2u) / (dz2u * (dzu + dz2u))
