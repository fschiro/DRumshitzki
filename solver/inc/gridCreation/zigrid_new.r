
# Generation of non-uniform grid in "z" direction (subenothelial intima) region.
# Since we expect significant variations close to the  edge of fenestra, we need 
# a dense grid there. Also, close to the junction, we would want a denser grid.
# Thus we form a non-uniform grid with decreasing interval size towads the
# ends (zi=0)&(zi=1) and a coarser grid in the center.

zigrid_new <- function(beta){
    #function [ s k1 zi ] <- zigrid_new(beta)

    # input arguments, beta <- grid spacing ration i.e.,
    #                           k1(2)<- beta * k1[1] , k1(3)<-beta^2 * k1[1]  etc
    #                  
    # output arguments, s <- grid points in "zi" direction excluding }  points
    #                   k1 <- array of grid spacings in "zi" direction
    #                   zi <- array of node positions in "zi" direction

    ## Original grid

    #     e <- 11    # we start with 5 elements i.e.,4 grid nodes excluding }  points for filtration6.m

    e <- 21     # for F_MT.m

    if (beta == 1){
        factor <- 1.0 / e
    }else{ 
        temp1 <- (e + 1.0) / 2.0
        temp2 <- (e - 1.0) / 2.0
        factor <- (1.0 - beta) / (2.0 - beta^temp1 - beta^temp2)
    } 

    dzi <- 1.0 * factor
    k1 <- dzi %>% c
    zi <- 0 %>% c

    for(i in seq( 2,(e + 3) / 2)){
        zi[i]  <- zi[(i-1)] + dzi
        dzi <- dzi * beta
    } 

    dzi <- dzi / (beta^2)

    for(i in seq( (e + 5) / 2,e + 1)){
        zi[i]  <- zi[i-1] + dzi
        dzi <- dzi / beta
    }                
    zi[length(zi)] <- 1.0

    for(i in seq( 2,length(zi)-1)){
        k1[i]  <- zi[i + 1] -zi[i] 
    } 

    s <- length(k1)-1

    ## Refining the original grid  

    k1_old <-k1
    elem <- length(k1_old)

    #     refinements <- input('enter the number of refinements you want from the original grid of 5 elements in SI \n')

    refinements <- 2
    #     refinements <- 1

    k1_new = c()
    zi_new = c()
    if (refinements >= 1){
        
        for(ref in seq(1,refinements)){
            #s<-2 * s + 1
            elem <- elem * 2

            for(i in seq( 1,elem)){

                # if (mod(i,2)~<-0)
                if(i %% 2 != 0){

                    k1_new[i]  <- 0.5 * k1_old[(i + 1) / 2]
                }else{ 
                    k1_new[i]  <- 0.5 * k1_old[i / 2]
                } 
            } 

            elem_new <- length(k1_new)
            zi_new[1] <-0

            for(i in seq( 2,elem_new + 1)){

                zi_new[i] <- zi_new[i-1] + k1_new[i-1]
            } 
            
            zi_new[elem_new + 1]<-1.0

            k1_old <- k1_new
        } 
        
        k1 <- k1_old
        zi <- zi_new
        s <- length(k1)-1
    }else{ 
    #         fprintf('The following results are based on original grid of 5 points in SI \n')
    } 
    # [ s k1 zi ]
    # list(s, k1, zi) %>% return()
    list(
        s = s,
        k1 = k1, 
        zi = zi
    ) %>% return()
}