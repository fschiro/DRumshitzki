1.  Fix endothelial cell math
  a. xi_nj is wrong should not be for both normal junction and EC
  b. Last equation of ECNJ wrong
  c. Write last eq ECNJ using xi_nj variable

2. add ip3j im3j ijp3 ijm3 to create_matrix_fun

3. dz_foward, dz_backward both use backward differences
  a. Need to compute forward differences for dz_forward
  b. repeat fix for r-direction

4. Add 2-layer boundary for intima-media
5. Re-create derivative scheme with beta coefficient variable names
6. Plan inverse, adding concentration to EC, concentration matrix docs
