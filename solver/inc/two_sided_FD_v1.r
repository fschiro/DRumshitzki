# See https://github.com/fschiro/DRumshitzki/blob/main/docs/Discritization.md

#beta_1 <- 
# ------------------------- #
# D2(P, r) * H_SQR
# ------------------------- #
# P(r, z) [- 2 / (Hb * Hf) ]
d2pdr_ij <- H_SQR * rep(-2 / (dr_forward * dr_backward), rows_in_z)
# P(r + Hf, z) 2 / (Hf * (Hb + Hf)) * P(r + Hf, z)
d2pdr_ijp1 <- H_SQR * rep(2 / (dr_forward * (dr_forward + dr_backward)), rows_in_z) 
# P(r - Hb, z) 2 / (Hb * (Hb + Hf)) * P(r - Hb, z)
d2pdr_ijm1 <- H_SQR * rep(2 / (dr_backward * (dr_forward + dr_backward)), rows_in_z)

# ------------------------- #
# D(P, r) * [1 / r] * H_SQR
# ------------------------- #
# P(r, z)  [- (Hb - Hf) / (Hb * Hf) ] 
dpdr_ij <- H_SQR * rep( (-dr_backward + dr_forward) / (dr_backward * dr_forward) * r_inverse, rows_in_z )
# P(r + Hf, z)  Hb / (Hf * (Hb + Hf)) 
dpdr_ijp1 <- H_SQR * rep( dr_backward / (dr_forward * (dr_forward + dr_backward) ) * 1 / r, rows_in_z )
# P(r - Hb, z)  Hf / (Hb * (Hb + Hf))
dpdr_ijm1 <- H_SQR * rep( dr_forward / (dr_backward * (dr_forward + dr_backward) ) * 1 / r, rows_in_z )

# ------------------------- #
# D2(P, z)
# ------------------------- #
# P(r, z)   -2 / (Hd * Hu)
d2pdz_ij <- - 2 / (dzu * dzd)
# P(r, z + Hd)    2 / (Hd * (Hd + Hu))
d2pdz_ip1j <- 2 / (dzd * (dzu + dzd)) 
# P(r, z - Hu)    2 / (Hu * (Hd + Hu)) 
d2pdz_im1j <- 2 / (dzu * (dzu + dzd))

# ------------------------- #
# D(P, z) (for endothelial cells)
# ------------------------- #
# D(P, z) = Hu / (Hd * (Hu + Hd)) * P(r, z + Hd) - (Hu - Hd) / (Hu * Hd) * P(r, z)  + Hd / (Hu * (Hu + Hd)) * P(r, z - Hu)

# P(r, z) = (Hu - Hd) / (Hu * Hd)
dpdz_ij <- (dzu - dzd) / (dzu * dzd)
# P(r, z + Hd) = Hu / [hd * (Hu + Hd)] + EC_BOTTOM_ONLY [ + a_j  ]
dpdz_ip1j <- dzu / ( dzd * (dzu + dzd) )
# P(r, z + Hd) = Hu / [hd * (Hu + Hd)] + EC_TOP_ONLY [ - a_j ]
dpdz_im1j <- dzd / ( dzu * (dzu + dzd) )

