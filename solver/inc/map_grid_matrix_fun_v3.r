library(magrittr)
library(Matrix)


xMapG <- function(stateVector, gridRows = 3, gridCols = 4){
# map a state vector to a matrix of values for each grid-point
	stateVector %>% Matrix(nrow = gridRows, ncol = gridCols, byrow = TRUE)
}

gMapX <- function(gridPoints, gridRows = 3, gridCols = 4){
    # map a matrix of grid-values to a state vector
    
    # i = row of physical grid
    # j = column of physical grid
    # matrix A's dimension is: NM x NM where N=gridRows, M=gridCols
    # return -1 if out of grid
    
	
	gridPoints$out <- (gridPoints[, 1] - 1) * gridCols + gridPoints[, 2]
	test1 <- gridPoints[, 1] > gridRows | gridPoints[, 1] <= 0
	test2 <- gridPoints[, 2] > gridCols | gridPoints[, 2] <= 0
	if(nrow(gridPoints[test1, ] ) > 0) gridPoints[test1, ]$out <- -1
	if(nrow(gridPoints[test2, ] ) > 0) gridPoints[test2, ]$out <- -1
	
	gridPoints$out %>% return()
}

gMapX_ipmx_jpmx <- function(gridPoints, gridRows = 4, gridCols = 5, add_i = 0, add_j = 0){
	cbind(
		gridPoints %>% gMapX(gridRows, gridCols),
		cbind(
			gridPoints[, 1] + add_i, 
			gridPoints[, 2] + add_j
		) %>% as.data.frame %>% gMapX(gridRows, gridCols)
	) %>% return
}




map_equations_to_matrix <- function(
        A, rows_in_z, rows_in_r, ij = NULL, 
        ip1j = NULL, ip2j = NULL, ip3j = NULL, im1j = NULL, im2j = NULL, im3j = NULL,
        ijp1 = NULL, ijp2 = NULL, ijp3 = NULL, ijm1 = NULL, ijm2 = NULL, ijm3 = NULL, 
        gridPoints = NULL
    ){
    # gridPoints should be output of expand.grid(seq( i_points), seq(j_points) )
        # null gridpoints creates new
    # A is matrix to update
    # ij, ip1j, im1j, ijp1, ijm1 are vectors of length gridpoints_x * gridpoints_y to add to matrix
    if(is.null(gridPoints)) gridPoints <- expand.grid(seq(rows_in_z), seq(rows_in_r))
    
	df = data.frame(
		key = c('ij', 'ip1j', 'ip2j', 'ip3j', 'im1j', 'im2j', 'im3j', 'ijp1', 'ijp2', 'ijp3', 'ijm1', 'ijm2', 'ijm3'),
		add_i = c(0, 1, 2, 3, -1, -2, -3, 0, 0, 0, 0, 0, 0),
		add_j = c(0, 0, 0, 0, 0, 0, 0, 1, 2, 3, -1, -2, -3)
	)
	matrices = list(ij, ip1j, ip2j, ip3j, im1j, im2j, im3j, ijp1, ijp2, ijp3, ijm1, ijm2, ijm3)
		
	for(i in seq(nrow(df))){
		if(!is.null(matrices[[i]])){
		
			index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = df$add_i[i], add_j = df$add_j[i] )			
			A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- matrices[[i]][ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
		}
	}	
	
	A %>% return()
    
}



map_equations_to_b_vector <- function(B, rows_in_z, rows_in_r, ij = NULL, ip1j = NULL, im1j = NULL, ijp1 = NULL, ijm1 = NULL, gridPoints = NULL){
    # gridPoints should be output of expand.grid(seq( i_points), seq(j_points) )
        # null gridpoints creates new
    # A is matrix to update
    # ij, ip1j, im1j, ijp1, ijm1 are vectors of length gridpoints_x * gridpoints_y to add to matrix
    
    # filters search for index[, 2] < 0 because these are the points of index in boundary
    # use index[, 1] because this is the vector equation for that grid point in B vector

    if(is.null(gridPoints)) gridPoints <- expand.grid(seq(rows_in_z), seq(rows_in_r))    
    
    if(!is.null(ij)){      
		index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r)	
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- ij[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(ip1j)){        
		index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = 1 )	
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1] ] <- ip1j[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(im1j)){
        index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_i = -1 )	
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- im1j[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }
    if(!is.null(ijp1)){
		index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_j = 1 )	
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- ijp1[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(ijm1)){        		
		index <- gridPoints %>% gMapX_ipmx_jpmx(rows_in_z, rows_in_r, add_j = -1 )	
        B[ index[index[, 2] < 0, 1]] <- ijm1[ index[index[, 2] < 0, 1]]
    }

    B %>% return()
}
