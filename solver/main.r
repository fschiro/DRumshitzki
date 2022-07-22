# ======================================================== #
# Load dependencies
# ======================================================== #


library(magrittr)

file.path('inc', 'map_grid_matrix_fun_v2.r') %>% source
# get shripad grid functions
file.path('inc', 'gridCreation', 'rGridMultipleNew.r') %>% source
file.path('inc', 'gridCreation', 'zggrid.r') %>% source
file.path('inc', 'gridCreation', 'zigrid_new.r') %>% source
file.path('inc', 'gridCreation', 'zmgrid_new.r') %>% source
file.path('inc', 'variables.r') %>% source
file.path('inc', 'one_sided_FD.r') %>% source
file.path('inc', 'two_sided_FD_v2.r') %>% source
