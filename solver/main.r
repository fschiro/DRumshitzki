# ======================================================== #
# Load dependencies
# ======================================================== #



library(magrittr)
stem <- "/media/frank/T7/"
root <- stem %>% paste0("dev/dRumschitzki Lab/r_solver_v2/")

root %>% paste0("inc/map_grid_matrix_fun.r") %>% source() # get map grid -> matrix
# get shripad grid functions
root %>% paste0("inc/gridCreation/rGridMultipleNew.r") %>% source() 
root %>% paste0("inc/gridCreation/zggrid.r") %>% source() 
root %>% paste0("inc/gridCreation/zigrid_new.r") %>% source() 
root %>% paste0("inc/gridCreation/zmgrid_new.r") %>% source() 
root %>% paste0("inc/gridCreation/zmgrid_new.r") %>% source() 
root %>% paste0("inc/variables.r") %>% source() 

#root %>% paste0("createGrid.r") %>% source() 
