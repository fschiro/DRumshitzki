# ==================================================================================== #
# See https://github.com/fschiro/DRumshitzki/blob/main/docs/Discritization.md
# ==================================================================================== #

# ===================== #
# D2(P, r) * H_SQR
# ===================== #
# P(r - Hb, z) 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)

beta_1 <- rep(2 / (dr_backward * (dr_forward + dr_backward)), rows_in_z)
# P(r, z) [- 2 / (Hb * Hf) ]
beta_2 <- rep(-2 / (dr_forward * dr_backward), rows_in_z)
# P(r + Hf, z) 2 / (Hf * (Hb + Hf)) * P(r + Hf, z)
beta_3 <- rep(2 / (dr_forward * (dr_forward + dr_backward)), rows_in_z) 


betaAlt_1 <- H_SQR * beta_1
# P(r, z) [- 2 / (Hb * Hf) ]
betaAlt_2 <- H_SQR * beta_2
# P(r + Hf, z) 2 / (Hf * (Hb + Hf)) * P(r + Hf, z)
betaAlt_3 <- H_SQR * beta_3

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
gamma_1 <- rep( dr_forward / (dr_backward * (dr_forward + dr_backward) ), rows_in_z )
gammaAlt_1 <- H_SQR * rep( dr_forward / (dr_backward * (dr_forward + dr_backward) ) * r_inverse, rows_in_z )
# P(r, z)  [- (Hb - Hf) / (Hb * Hf) ] 
gamma_2 <- rep( (-dr_backward + dr_forward) / (dr_backward * dr_forward), rows_in_z )
gammaAlt_2 <- H_SQR * rep( (-dr_backward + dr_forward) / (dr_backward * dr_forward) * r_inverse, rows_in_z )
# P(r + Hf, z)  Hb / (Hf * (Hb + Hf)) 
gamma_3 <- rep( dr_backward / (dr_forward * (dr_forward + dr_backward) ), rows_in_z )
gammaAlt_3 <- H_SQR * rep( dr_backward / (dr_forward * (dr_forward + dr_backward) ) * r_inverse, rows_in_z )

# ========================== #
# D(P, z) (for endothelial cells)
# ========================== #
# P(r, z - Hd) = Hd / [hu * (Hu + Hd)] + EC_TOP_ONLY [ - a_j ]
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

c(betaAlt_1, betaAlt_2, betaAlt_3) %>% max
c(beta_4, beta_5, beta_6) %>% max
c(gammaAlt_1, gammaAlt_2, gammaAlt_3) %>% max
c(gamma_4, gamma_5, gamma_6) %>% max





# ================================================== #
# Rumschitzki scheme dev
# ================================================== #
{
    test_beta_1 <- rep( (dr_backward / dr_forward) / (dr_forward + dr_backward), rows_in_z)

    j_ = which(test_beta_1 == max(test_beta_1))
    dr_backward[j_[1]] %>% as.character %>% as.character %>% sprintf('backward-spacing: %s', .) %>% print
    dr_forward[j_[1]] %>% as.character %>% sprintf('forward-spacing: %s', .) %>% print
    (dr_backward / dr_forward)[j_[1]] %>% as.character %>% sprintf('backward / forward: %s', .) %>% print
    (dr_forward + dr_backward)[j_[1]] %>% as.character %>% sprintf ('backward + forward: %s', .) %>% print
    (dr_backward[j_[1]] / dr_forward[j_[1]]) / (dr_forward[j_[1]] + dr_backward[j_[1]]) %>% as.character %>% sprintf('coefficient: %s', .) %>% print
}
# [1] "backward-spacing: 0.0162999632694447"
# [1] "forward-spacing: 8.83499495785145e-10"
# [1] "backward / forward: 18449318.1345388"
# [1] "backward + forward: 0.0162999641529442"
# [1] "coefficient: 0.0162999641529442"

# test_beta_2 %>% max %>% print
# test_beta_3 %>% max %>% print
# test_beta_2 <- rep((dr_forward - dr_backward) / (dr_forward * dr_backward), rows_in_z)
# test_beta_3 <- rep((dr_forward / dr_backward) / (dr_forward + dr_backward), rows_in_z) 
# test_beta_1 %>% max %>% print