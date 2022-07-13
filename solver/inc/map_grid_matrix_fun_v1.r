# ============================================================== #
# Overview
# ============================================================== #
# These functions map grid space to matrix space
# used to easily build matrix equations


library(magrittr)
library(Matrix)

# Grid maps to X by concatenating rows
# Grid[i, j] is the (i - 1) * gridCols + j component of vector X
# Thus the (i - 1) * gridCols + j column of A is the multiple for X vector
# and the (i - 1) * gridCols + j row of A is the row that computes the value of pressure for Grid[i, j]


# assume grid = 10 row 100 column -> A = (10x100) * (10x100) = 1000 x 1000

# ========================================= #
# Map from grid G to vector x in Ax + b
# ========================================= #
gMapX <- function(i, j, gridRows = 3, gridCols = 4){
    # i = row of physical grid
    # j = column of physical grid
    # matrix A's dimension is: NM x NM where N=gridRows, M=gridCols
    # return -1 if out of grid
    if(i > gridRows | i <= 0) return(-1)
    if(j > gridCols | j <= 0) return(-1)
    (i - 1) * gridCols + j %>% return()
}


# ============================================================== #
# Map center point [i, j] to A[gMapX[i, j], gMapX[i, j]]
# ============================================================== #
gMapX_i_j <- function(i, j, gRows = 4, gCols = 5){
    gMapX(i, j, gRows, gCols) %>% c(., .)
}

# ============================================================== #
# Map center point [i, j] to A[gMapX[i, j], gMapX[i + 1, j]]
# ============================================================== #
gMapX_iP1_j <- function(i, j, gRows = 4, gCols = 5){
    c(
        gMapX(i, j, gRows, gCols),
        gMapX(i + 1, j, gRows, gCols)
    )

}
# ============================================================== #
# Map center point [i, j] to A[gMapX[i, j], gMapX[i - 1, j]]
# ============================================================== #
gMapX_iM1_j <- function(i, j, gRows = 4, gCols = 5){
    c(
        gMapX(i, j, gRows, gCols),
        gMapX(i - 1, j, gRows, gCols)
    )

}
# ============================================================== #
# Map center point [i, j] to A[gMapX[i, j], gMapX[i, j+ 1]
# ============================================================== #
gMapX_i_jM1 <- function(i, j, gRows = 4, gCols = 5){
    c(
        gMapX(i, j, gRows, gCols),
        gMapX(i, j - 1, gRows, gCols)
    )

}
# ============================================================== #
# Map center point [i, j] to A[gMapX[i, j], gMapX[i, j - 1]
# ============================================================== #
gMapX_i_jP1 <- function(i, j, gRows = 4, gCols = 5){
    c(
        gMapX(i, j, gRows, gCols),
        gMapX(i, j + 1, gRows, gCols)
    )

}
# ============================================================== #
# Find the coefficient that multiplies a (i+x1, j+x2) for given center point (i, j)
# Map center point [i, j] to A[gMapX[i, j], gMapX[i + add_i, j +  + add_j]
# Useful when we have a multiple of say a point 2-rows away in grid.
# ============================================================== #
gMapX_ipmx_jpmx <- function(i, j, gRows = 4, gCols = 5, add_i = 0, add_j = 0){
    c(
        gMapX(i, j, gRows, gCols),
        gMapX(i + add_i, j + add_j, gRows, gCols)
    )

}

# ======================================================== #
# Function to map 5 equations to (i, j), (i+1, j), (i-1, j), (i, j+1), (i, j-1)
# If you call negative index in matrix you get error so can't have values where i or j -1
# if you call positive values no error for some reason so i+1 works
# ======================================================== #
map_equations_to_matrix <- function(
        A, rows_in_z, rows_in_r, ij = NULL, 
        ip1j = NULL, im1j = NULL, ip2j = NULL, im2j = NULL,
        ijp1 = NULL, ijm1 = NULL, ijp2 = NULL, ijm2 = NULL, 
        gridPoints = NULL
    ){
    # gridPoints should be output of expand.grid(seq( i_points), seq(j_points) )
        # null gridpoints creates new
    # A is matrix to update
    # ij, ip1j, im1j, ijp1, ijm1 are vectors of length gridpoints_x * gridpoints_y to add to matrix
    if(is.null(gridPoints)) gridPoints <- expand.grid(seq(rows_in_z), seq(rows_in_r))
    gridPoints %<>% split(., seq(nrow(.)))
    
    if(!is.null(ij)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ij[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }

    if(!is.null(ip1j)){
        index <- gridPoints %>% lapply(function(x) gMapX_iP1_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ip1j[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }

    if(!is.null(im1j)){
        index <- gridPoints %>% lapply(function(x) gMapX_iM1_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- im1j[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }
    
    if(!is.null(im2j)){
        index <- gridpoints %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = -2)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- im2j[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }
    if(!is.null(ip2j)){
        index <- gridpoints %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_i = 2)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ip2j[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }


    if(!is.null(ijp1)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_jP1(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ijp1[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }

    if(!is.null(ijm1)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_jM1(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0 ,] ] <- ijm1[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }

    if(!is.null(ijm2)){
        index <- gridpoints %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_j = -2)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ijm2[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
    }
    if(!is.null(ijp2)){
        index <- gridpoints %>% lapply(function(x) gMapX_ipmx_jpmx(x[[1]], x[[2]], rows_in_z, rows_in_r, add_j = 2)) %>% do.call(rbind, .)
        A[ index[index[, 1] > 0 & index[, 2] > 0, ] ] <- ijp2[ index[index[, 1] > 0 & index[, 2] > 0, 1] ]
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
    gridPoints %<>% split(., seq(nrow(.)))
    
    if(!is.null(ij)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- ij[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(ip1j)){
        index <- gridPoints %>% lapply(function(x) gMapX_iP1_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1] ] <- ip1j[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(im1j)){
        index <- gridPoints %>% lapply(function(x) gMapX_iM1_j(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- im1j[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }
    if(!is.null(ijp1)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_jP1(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        B[ index[index[, 1] > 0 & index[, 2] < 0, 1]] <- ijp1[ index[index[, 1] > 0 & index[, 2] < 0, 1]]
    }

    if(!is.null(ijm1)){
        index <- gridPoints %>% lapply(function(x) gMapX_i_jM1(x[[1]], x[[2]], rows_in_z, rows_in_r)) %>% do.call(rbind, .)
        B[ index[index[, 2] < 0, 1]] <- ijm1[ index[index[, 2] < 0, 1]]
    }

    B %>% return()
}
