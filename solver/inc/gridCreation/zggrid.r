
# Generation of non - uniform grid in "z" direction (glycocalyx) region.
# Since we expect significant variations close to normal junction, we need 
# a dense grid there. Thus we form a non - uniform grid with increasing interval size
# from top of EC (zg <-0) towards the lumen (zg <-1)

zggrid <- function(delta){
    # function [ g k3 zg ] <-zggrid(delta)

    # input arguments,  delta <-grid spacing ration i.e.,
    #                           k3(2) <- delta * k3(1), k3(3) <-delta^2 * k3(1) etc
    #                  
    # output arguments,  g <-grid points in "zg" direction excluding } points
    #                   k3 <-array of grid spacings in "zg" direction
    #                   zg <-array of node positions in "zg" direction

    ## Original grid

    g <- 11    # we start with 6 elements i.e., 5 grid nodes excluding } points

    if (delta == 1){
        factor <- 1.0/6.0
    }else{
        factor <-(1 - delta)/(1 - delta^(g + 1))
    }

    dzg <- 1.0 * factor

    k3 <- c( dzg)

    zg <- c(0)

    for(i in seq(2, g + 2)){

        zg[i] <-zg[i - 1] + dzg

        dzg <- dzg * delta
    }
    zg[g + 2] <-1.0

    for(i in seq(2, g + 1)){

        k3[i] <- delta^(i - 1) * k3[1]
    }

    ## Refining the original grid  

    k3_old <- k3
    elem <- length(k3_old)

    #     refinements <-input('enter the number of refinements you want from the \noriginal grid of 6 elements in GX\n')

    #     refinements <-3
    refinements <- 2
    k3_new <- c()
    if (refinements >= 1){
        
        for(ref in seq(1, refinements)){
            g <- 2 * g + 1
            elem <- elem * 2

            for(i in seq(1, elem)){

                #if (mod(i,2)~ <-0)
                if(i %% 2 != 0){
                    k3_new[i] <-0.5 * k3_old[(i + 1)/2]
                }else{
                    k3_new[i] <-0.5 * k3_old[i / 2]
                }
            }

            elem_new <- length(k3_new)
            zg_new <- c(0)

            for(i in seq(2, elem_new + 1)){

                zg_new[i] <- zg_new[i - 1] + k3_new[i - 1]
            }
            
            zg_new[elem_new + 1] <- 1.0

            k3_old <- k3_new
        }
        
        k3 <- k3_old
        zg <- zg_new
    }else{
    #         fprintf('The following results are based on original grid of 6 elements of GX \n')
    }
    # function [ g k3 zg ] <-zggrid(delta)
    # list(g, k3, zg) %>% return()
    list(
        g = g,
        k3 = k3, 
        zg = zg
    ) %>% return()
} 