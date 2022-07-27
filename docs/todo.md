1. Why are there Inf in Pressure matrix? See PRESSURE_MAT[1:5, 1:5]
2. inverse pressure matrix  
    i. Note this works and gives results: solve(PRESSURE_MAT[1:30, 1:30], tail(PRESSURE_BV, 30))
    i. QR factorization
    ii. Read: https://stackoverflow.com/questions/57833421/computation-of-inverse-of-a-matrix-having-dimensions-25000-by-25000-in-r
    iii. Read: https://www.r-bloggers.com/2015/07/dont-invert-that-matrix-why-and-how/
    iv. Ask Rumshitzki about solving for Pressure in step-1, matrix too big for normal inversion. 
3. Create: build_concentration_matrix.r  3
4. Rumschitzki two-sided difference scheme   
