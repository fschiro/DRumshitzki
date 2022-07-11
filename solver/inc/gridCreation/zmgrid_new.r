
# Generation of non-uniform grid in "z" direction (media) region.
# Since we expect significant variations close to fenestra, we need 
# a dense grid there. Thus we form a non-uniform grid with decreasing interval size
# from bottom (zm<--1) towards the center (zm<-0)

zmgrid_new <- function(gamma){
    # function [ m k2 zm ] <- zmgrid_new[gamma)

    # input arguments, gamma <- grid spacing ration i.e.,
    #                           k2(2)<- gamma * k2(1), k2(3)<-gamma^2 * k2(1) etc
    #                  
    # output arguments, m <- grid points in "zm" direction excluding } points
    #                   k2 <- array of grid spacings in "zm" direction
    #                   zm <- array of node positions in "zm" direction

    ## Original grid


    e <- 11     # for F_MT.m

    if (gamma == 1){
        factor <- 1.0/e
    }else{
        temp1 <- (e + 1.0)/2.0
        temp2 <- (e-1.0)/2.0
        factor <- (1.0 - gamma) / (2.0 - gamma^temp1 - gamma^temp2)
    }

    dzm <- 1.0 * factor
    k2 <- dzm %>% c
    zm <- 0 %>% c

    for(i in seq(2,(e + 3)/2)){
        zm[i] <- zm[i - 1] + dzm
        dzm <- dzm * gamma
    }

    dzm <- dzm / (gamma^2)

    for(i in seq((e + 5)/2,e + 1)){
        zm[i] <- zm[i - 1] + dzm
        dzm <- dzm / gamma
    }               
    zm[length(zm)] <- 1.0

    for(i in seq(2,length(zm)-1)){
        k2[i] <- zm[i + 1]-zm[i]
    }

    m <- length(k2)-1
    ## Refining the original grid  

    k2_old <-k2
    elem <- length(k2_old)
        
    #     refinements <- input('\n enter the number of refinements you want from the \noriginal grid of 5 elements in media \n')

    refinements <- 3
    #     refinements <- 3
    k2_new <- c()
    if (refinements >= 1){
        
        for(ref in seq(1,refinements)){
            m <- 2 * m + 1
            elem <- elem * 2

            for(i in seq(1,elem)){

                #if (mod(i,2)~<-0)
                if(i %% 2 != 0){
                    k2_new[i] <- 0.5 * k2_old[(i + 1)/2]
                }else{
                    k2_new[i] <- 0.5 * k2_old[i/2]
                }
            }

            elem_new <- length(k2_new)
            zm_new <- c(0)

            for(i in seq(2,elem_new + 1)){

                zm_new[i] <- zm_new[i - 1] + k2_new[i - 1]
            }
            
            zm_new[elem_new + 1] <- 1.0

            k2_old <- k2_new
        }
        
        k2 <- k2_old
        zm <- zm_new
        m <- length(k2)-1
    }else{
    #         fprintf('The following results are based on original grid of 10 points in media \n')
    }
    # [ m k2 zm ]
    # list(m, k2, zm) %>% return()
    list(
        m = m,
        k2 = k2, 
        zm = zm
    ) %>% return()
}