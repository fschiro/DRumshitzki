

# =============================================== #
# Problem 1: non-finite values in matrix
# =============================================== #
1. Why Inf = (1, 2) ?
	Answer: Because gammaAlt_3[1] = Inf
	A. Why gammaAlt_3[1] = Inf? 
		Answer: Because r_inverse[1] = Inf
		i. Why r_inverse[1] = Inf? 
			Answer: Because r[1] = 0 !
				Knowledge needed: What to do with 1/r term in difference scheme?
			

2. Why gammaAlt_2[1] = NaN ? 
	Answer: Because r[1] = 0
		x = 0 -> x/0 = NaN
		x <> 0 -> x/0 = Inf

To solve: 
	Q. Framework for 1/r at r = 0 ? 
		The equation for interior grid-points is h^2(D2(P, r) + 1/r D(P, r)) + D2(P, Z) = 0
		So at the first point r = 0 how to treat 1/r? 
	A. Consider r = 0 to be the boundary

This problem was solved	by removing first point of r vector (r = 0) and treating that as boundary. 

# =============================================== #
# Problem 2: after fixing problem 1, 
#	check entire matrix for non-finite values 
# =============================================== #

any(!is.finite(PRESSURE_MAT@x)) # flag true if exists +-inf, NA, NaN
subset(summary(PRESSURE_MAT), !is.finite(x))

1. Finding NA in dataset, I know j < i this implies issue with im1j OR ijm1. 
	A. I narrowed this down to endothelial cell math
		i. Through process of ellimination I found that setting ip2j = -xi_g_ec caused the error, where -xi_g_ec = -39380761246
			a. I see that I need to get all units correct as M or MM, M^2 or MM^2 
		ii. After isolating one element of pressure-mat before and after substraction of -xi_g_ec, I believe the error is in map_equations_to_matrix for ip2j
			a. The solution: Dont enter constant into map_equations_to_matrix, instead, multiply by matrix of grid dimensions with 1 everywhere		

The problem was solved by creating a matrix of ones and multiplying constants by 1 before applying to grid




# =============================================== #
# Example:
# Here is how to test for finite values in matrix 
# Also how to find their locations
# =============================================== #


any(!is.finite(PRESSURE_MAT@x)) # flag true if exists +-inf, NA, NaN
subset(summary(PRESSURE_MAT), !is.finite(x))


# =============================================== #
# Example:
# Here is a good way to isolate a non-finite point for testing
# =============================================== #

	test <- PRESSURE_MAT %>% map_equations_to_matrix(
		rows_in_z, rows_in_r, 
		ij = omega_6,
		ip1j = zeros,
		im1j = omega_5 + xi_g_ec,
		ip2j = -xi_g_ec,
		#im2j = omega_4,
		#ijp1 = NULL, # default value is zero and we have not edited this previously 
		#ijm1 = NULL, # default value is zero and we have not edited this previously
		#ijp2 = NULL, # default value is zero and we have not edited this previously
		#ijm2 = NULL, # default value is zero and we have not edited this previously
		gridPoints = ec1_gridPoints
	)
	
	any(!is.finite(test@x))
	index <- subset(summary(test), !is.finite(x))
	PRESSURE_MAT[index[1, ]$i, index[1, ]$j] - xi_g_ec # 0
	test[index[1, ]$i, index[1, ]$j]  # NA
	
	




!!R2 + R3!!

