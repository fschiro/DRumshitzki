rgrid_multiplenew <- function(alpha1, alpha2, alpha3, alpha4){
    #rgrid_multiplenew.m
    # input arguments: alpha1 <- grid spacing ratio in fenestral region i.e.,
    #                           h(2)<- alpha1*h(1), h(3)<-alpha1^2*h(1) etc
    #                  alpha2 <- similar grid spacing ratio in IEL (close to
    #                           fenestra)
    #                  alpha3 <- similar grid spacing ratio in IEL (close to
    #                           RHS)
    #                  alpha4 <- similar grid spacing ratio in junction
    # output arguments: r <- grid points in "r" direction excluding end points
    #                   v <- grid points in fenestral hole
    #                   e1 <- number of elements in fenestra
    #                   e2 <- number of elements in 1st part of IEL 
    #                   e3 <- number of elements in 2nd part of IEL
    #                   e4 <- number of elements in junction
    #                   pec <- points on endothelial cell
    #                   h <- array of grid spacings in "r" direction
    #                   a <- array of node positions in "r" direction

    library(magrittr)

    # alpha1 <- 2.0
    # alpha2 <- 1.8
    # alpha3 <- 0.94
    # alpha4 <- 20

    e1 <- 11
    if (alpha1 == 1.0){
        factor1 <- 1.0 / e1
    }else{
        temp1 <- (e1 + 1.0) / 2.0
        temp2 <- (e1 - 1.0) / 2.0
        factor1 <- (1.0 - alpha1) / (2.0 - alpha1^temp1 - alpha1^temp2)
    }

    dr1 <- 1.000000000000001 * factor1
    h1 <- c(dr1)
    a1 <- c(0)
    for(i in seq(2, (e1 + 3) / 2)){
        a1 %<>%  c(a1[i - 1] + dr1)
        dr1 <- dr1 * alpha1
    }

    dr1 <- dr1 / (alpha1^2)

    for(i in seq((e1 + 5) / 2, e1 +1)){
        a1 %<>%  c(a1[i - 1] + dr1)
        dr1 <- dr1 / alpha1
    }
    a1[length(a1)] <- 1.000000000000001

    for(i in seq(2, length(a1) - 1)){
        h1 %<>% c(a1[i + 1] - a1[i])
    }

    a1 %>% data.frame(x = ., y = rep(1, length(.))) %>% plot
    h1 %>% data.frame(x = ., y = rep(1, length(.))) %>% plot




        
    # For 1st region of IEL region, a(11) is same in both as it is at the edge
        
    e2 <- 10

    if (alpha2 == 1.0){
        
        factor2 <- 1.0 / e2
    }else{
        factor2 <- (1 - alpha2) / (1 - alpha2^(e2)) # we start with 10 elements in 1st part of IEL
    }

    dr2 <- (8.0 - 1.000000000000001) * factor2 
    #     dr2 <- (5.0 - 1.0) * factor2
    h2 <- c(dr2)

    for(i in seq(2, e2)){
        h2 %<>% c(alpha2^(i - 1) * h2[1])
    }

    h2 %>% data.frame(x = ., y = rep(1, length(.))) %>% plot

    # 2nd part of IEL    
    e3 <- 10

    if (alpha3 == 1.0){
        
        factor3 <- 1.0 / e3
    }else{
        factor3 <- (1 - alpha3) / (1 - alpha3^(e3)) # we start with 10 elements in 2nd part of IEL. 
    }

    dr3 <- (14.99999992 - 8.0) * factor3 
    #     dr3 <- (15.0 - 5.0) * factor3
    h3 <- c(dr3)

    for(i in seq(2, e3)){
        h3 %<>% c(alpha3^(i - 1) * h3[1])
    }

    h3 %>% data.frame(x = ., y = rep(1, length(.))) %>% plot

    # Normal junction   
        
    e4 <- 11

    if (alpha4 == 1){
        factor4 <- 1.0 / e4
    }else{
        temp1 <- (e4 + 1.0) / 2.0
        temp2 <- (e4 - 1.0) / 2.0
        factor4 <- (1.0 - alpha4) / (2.0 - alpha4^temp1 - alpha4^temp2)
    }

    dr4 <- (15.0125 - 14.99999992) * factor4 
    h4 <- c(dr4)
    x <- c(14.99999992)

    for(i in seq(2, (e4 + 3) / 2)){
        x %<>% c(x[i - 1] + dr4)
        dr4 <- dr4 * alpha4
    }

    dr4  <- dr4  / (alpha4^2)

    for (i in seq((e4 + 5) / 2, e4 + 1)){
        x[i] <- x[i - 1] + dr4 
        dr4  <- dr4  / alpha4
    }
    x[length(x)] <- 15.0125

    for( i in seq(2, length(x) - 1)){
        h4[i] <- x[i + 1] - x[i]
    }

    h4 %>% data.frame(x = ., y = rep(1, length(.))) %>% plot
    x %>% data.frame(x = ., y = rep(1, length(.))) %>% plot



    e1 <- h1 %>% length
    e2 <- h2 %>% length
    e3 <- h3 %>% length
    e4 <- h4 %>% length
        
    h <- c(h1, h2, h3, h4)
        
    a <- c(0)   
    for(i in seq(2, length(h) + 1)){
        a %<>% c(a[i - 1]  +  h[i - 1])
    }

    h %>% data.frame(x = ., y = rep(1, length(.))) %>% plot
    a %>% data.frame(x = ., y = rep(1, length(.))) %>% plot


    a[e1 + 1] <- 1.000000000000001
    a[e1 + e2 + 1] <- 8.0
    a[e1 + e2 + e3 + 1] <- 14.99999992

    a[length(a)] <- 15.0125

    r <- length(h)  -  1
        
    a %>% data.frame(x = ., y = rep(1, length(.))) %>% plot

    ## Refining the original grid  

    h1_old <- h1
    elem1 <- length(h1_old)
    h2_old <- h2
    elem2 <- length(h2_old)
    h3_old <- h3
    elem3 <- length(h3_old)
    h4_old <- h4
    elem4 <- length(h4_old)
        
    #     ref1 <- input('enter the number of refinements you want in fenestra\n')
    #     ref2 <- input('enter the number of refinements you want in first part of IEL\n')
    #     ref3 <- input('enter the number of refinements you want in second part of IEL\n')
    #     ref4 <- input('enter the number of refinements you want in normal junction\n')
        
    ref1 <- 3
    ref2 <- 5
    ref3 <- 5
    ref4 <- 2

    h1_new <- c()
    for( ref in seq(1, ref1)){

        elem1 <- elem1 * 2

        for( i in seq(1, elem1)){

            #if (!mod(i, 2) == 0){
            if(! i %% 2 == 0){
                h1_new[i] <- 0.5 * h1_old[(i + 1) / 2]
            }else{
                h1_new[i] <- 0.5 * h1_old[i / 2]
            }
        }
        
        h1_old <- h1_new
    }

    h1 <- h1_old
    e1 <- length(h1)  # number of elements in fenestra

    h2_new <- c()
    for( ref in seq(1, ref2)){

        elem2 <- elem2 * 2

        for( i in seq(1, elem2)){

            #if (mod(i,2) ~ <- 0){
            if(! i %% 2 == 0){
                h2_new[i] <- 0.5 * h2_old[(i + 1) / 2]
            }else{
                h2_new[i] <- 0.5 * h2_old[i / 2]
            }
        }
        
        h2_old <- h2_new
    }

    h2 <- h2_old
    e2 <- length(h2)  # number of elements in first part of IEL

    h3_new <- c()
    for( ref in seq(1, ref3)){
        
        elem3 <- elem3 * 2

        for (i in seq(1, elem3)){

            if(! i %% 2 == 0){
                h3_new[i] <- 0.5 * h3_old[(i + 1) / 2]
            }else{
                h3_new[i] <- 0.5 * h3_old[i / 2]
            }
        }
        
        h3_old <- h3_new
    }

    h3 <- h3_old
    e3 <- length(h3)  # number of elements in secod part of IEL

    h4_new <- c()
    for( ref in seq(1, ref4)){

        elem4 <- elem4 * 2

        for( i in seq(1, elem4)){

            if(! i %% 2 == 0){
                h4_new[i] <- 0.5 * h4_old[(i + 1) / 2]
            }else{
                h4_new[i] <- 0.5 * h4_old[i / 2]
            }
        }

        h4_old <- h4_new
    }

    h4 <- h4_old
    e4 <- length(h4)  # number of elements in junction

    h <- c(h1, h2, h3, h4)

    a <- c(0)

    for( i in seq(2, length(h) + 1)){
        
        a %<>% c(a[i - 1]  +  h[i - 1])
    }

    a[e1 + 1] <- 1.000000000000001
    a[e1 + e2 + 1] <- 8.0
    a[e1 + e2 + e3 + 1] <- 14.99999992
    a[length(a)] <- 15.0125

    h %>% data.frame(x = ., y = rep(1, length(.))) %>% plot
    a %>% data.frame(x = ., y = rep(1, length(.))) %>% plot

    r <- length(h)  -  1

    v <- 0
    for( i in seq(1, length(a))){

        if (a[i] < 1.0){

            v <- v + 1
        }
    }

    jn <- 0
    for( i in seq(1, length(a))){
        
        if (a[i] > 15.0){
            jn <- jn + 1
        }
    }
    #     fprintf('number of points in junction<- #g\n',jn)

    pec <- r + 2 - jn



    #[ r f e1 e2 e3 e4 pec h a ] 
    list(
        r = r, 
        v = v, 
        e1 = e1, 
        e2 = e2, 
        e3 = e3, 
        e4 = e4, 
        pec = pec, 
        h = h, 
        a = a
    ) %>% return()
}
