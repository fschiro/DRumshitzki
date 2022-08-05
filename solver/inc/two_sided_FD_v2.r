# ==================================================================================== #
# See https://github.com/fschiro/DRumshitzki/blob/main/docs/Discritization.md
# ==================================================================================== #

# ===================== #
# D2(P, r) * H_SQR
# ===================== #
# P(r - Hb, z) 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)
betaAlt_1 <- H_SQR * rep(2 / (dr_backward * (dr_forward + dr_backward)), rows_in_z)
# P(r, z) [- 2 / (Hb * Hf) ]
betaAlt_2 <- H_SQR * rep(-2 / (dr_forward * dr_backward), rows_in_z)
# P(r + Hf, z) 2 / (Hf * (Hb + Hf)) * P(r + Hf, z)
betaAlt_3 <- H_SQR * rep(2 / (dr_forward * (dr_forward + dr_backward)), rows_in_z) 

# ========================== #
# D2(P, z)
# ========================== #
# P(r, z - Hu)    2 / (Hu * (Hd + Hu)) 
beta_4 <- 2 / (dzu * (dzu + dzd))
# P(r, z)   -2 / (Hd * Hu)
beta_5 <- - 2 / (dzu * dzd)
# P(r, z + Hd)    2 / (Hd * (Hd + Hu))
beta_6 <- 2 / (dzd * (dzu + dzd)) 

# ========================== #
# D(P, r) * [1 / r] * H_SQR
# ========================== #
# P(r - Hb, z)  Hf / (Hb * (Hb + Hf))
gammaAlt_1 <- H_SQR * rep( dr_forward / (dr_backward * (dr_forward + dr_backward) ) * r_inverse, rows_in_z )
# P(r, z)  [- (Hb - Hf) / (Hb * Hf) ] 
gammaAlt_2 <- H_SQR * rep( (-dr_backward + dr_forward) / (dr_backward * dr_forward) * r_inverse, rows_in_z )
# P(r + Hf, z)  Hb / (Hf * (Hb + Hf)) 
gammaAlt_3 <- H_SQR * rep( dr_backward / (dr_forward * (dr_forward + dr_backward) ) * r_inverse, rows_in_z )

# ========================== #
# D(P, z) (for endothelial cells)
# ========================== #
# P(r, z + Hd) = Hd / [hu * (Hu + Hd)] + EC_TOP_ONLY [ - a_j ]
gamma_4 <- dzd / ( dzu * (dzu + dzd) )
# P(r, z) = (Hu - Hd) / (Hu * Hd)
gamma_5 <- (dzu - dzd) / (dzu * dzd)
# P(r, z + Hd) = Hu / [hd * (Hu + Hd)] + EC_BOTTOM_ONLY [ + a_j  ]
gamma_6 <- dzu / ( dzd * (dzu + dzd) )


# ================================================== #
# Run some tests & quit program if tests fail 
# ================================================== #

finiteTest(betaAlt_1, 'betaAlt_1')
finiteTest(betaAlt_2, 'betaAlt_2')
finiteTest(betaAlt_3, 'betaAlt_3')
finiteTest(beta_4, 'beta_4')
finiteTest(beta_5, 'beta_5')
finiteTest(beta_6, 'beta_6')
finiteTest(gammaAlt_1, 'gammaAlt_1')
finiteTest(gammaAlt_2, 'gammaAlt_2')
finiteTest(gammaAlt_3, 'gammaAlt_3')
finiteTest(gamma_4, 'gamma_4')
finiteTest(gamma_5, 'gamma_5')
finiteTest(gamma_6, 'gamma_6')


