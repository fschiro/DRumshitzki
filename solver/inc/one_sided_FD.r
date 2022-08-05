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



# ================================================== #
# Run some tests & quit program if tests fail 
# ================================================== #

finiteTest(omega_1, 'omega_1')
finiteTest(omega_2, 'omega_2')
finiteTest(omega_3, 'omega_3')
finiteTest(omega_4, 'omega_4')
finiteTest(omega_5, 'omega_5')
finiteTest(omega_6, 'omega_6')
