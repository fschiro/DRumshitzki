# Intima-Media Non-Finestra

There are two rows in the grid for this boundary.

Grid:   
1. Intima interior end  
2. Intima-media boundary 1 (IM1)  
3. Intima-media boundary 2 (IM2)  
4. Media interior start  
 
For derivatives we are using one-sided second-order difference at the boundary.


## Equations

Equation (22-23) from Shripad 2020

$$
\begin{align}
&\frac{\partial C_j}{\partial z_j} = 0 ; \\,\\, j \in \\{i, m\\} \\\\[10pt]
\end{align}
$$

# Discritization

### IM1

$$
\begin{align}
0 = & C(r, z) \times \omega_6 \\\\[10pt] 
& C(r, z - 1) \times \omega_5 \\\\[10pt] 
& C(r, z - 2) \times \omega_4 \\\\[10pt] 
\end{align} 
$$

<!--  
0 = & \omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\\\[10pt]
-->


### IM2


$$
\begin{align}
0 = & C(r, z) \times \omega_3 \\\\[10pt] 
& C(r, z + 1) \times \omega_2 \\\\[10pt] 
& C(r, z + 2) \times \omega_1 \\\\[10pt] 
\end{align} 
$$


