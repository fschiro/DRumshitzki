# Endothelial Cell

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
& \frac{D_i}{L^{\ast}_i} \times ( \frac{\partial C_i}{\partial z_i} - P_{ezi} \times C_i) = \frac{D_m}{L^{\ast}_m} \times ( \frac{\partial C_m}{\partial z_m} - P_{ezm} \times C_m) \\\\[10pt]
& \frac{C_i}{\gamma_i} = \frac{C_m}{\gamma_m} \\\\[10pt]
\end{align}
$$

Where:   

$$
\begin{align}
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j^{\ast}, r_f^{\ast}, L_j^{\ast} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are the dimensional velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
\end{align}
$$

## Transforming The Equations

As shown in (link to interior grid equations), the discritization of the interior equation is as follows: 

Let $\iota = \frac{f_j Pl^{\ast} }{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu} $  
Then, 

$$
\begin{align}
P_{erj} = & U_j \times \iota   \\\\[10pt]
P_{ezj} = & W_j \times \iota   \\\\[10pt]
\end{align}
$$ 

Plugging $\iota$ into the interior equation:  

$$
\begin{align}
0 = & \frac{D_i}{L^{\ast}_i} \times ( \frac{\partial C_i}{\partial z_i} - P_{ezi} \times C_i) - \frac{D_m}{L^{\ast}_m} \times ( \frac{\partial C_m}{\partial z_m} - P_{ezm} \times C_m) + \frac{C_i}{\gamma_i} - \frac{C_m}{\gamma_m} \\\\[10pt]
\end{align}
$$

Where, if at Finestra-intima boundary, $C_i = C(r, z)$ and $C_m = C(r, z + 1)$.  
If at Finestra-Media boundary, $C_m = C(r, z)$ and $C_m = C(r, z - 1)$

# Discritization

### IM1

$$
\begin{align}
0 = & C(r, z) \times ( \frac{ -D_i }{ L_i^{\ast} } \times \iota \times W + \omega_3 \times \frac{ D_i }{ L_i^{\ast} } + \frac{1}{\gamma_i}) \\\\[10pt]  
& C(r, z - 1) \times \omega_2 \times \frac{ D_i }{ L_i^{\ast} } \\\\[10pt] 
& C(r, z - 2) \times \omega_1 \times \frac{ D_i }{ L_i^{\ast} } \\\\[10pt] 
& C(r, z + 1) \times \frac{ -D_m }{ L_m^{\ast} } \times (\omega_6 - \iota \times W) - \frac{1}{\gamma_m} \\\\[10pt] 
& C(r, z + 2) \times \frac{ -D_m }{ L_m^{\ast} } \times \omega_5 \\\\[10pt] 
& C(r, z + 3) \times \frac{ -D_m }{ L_m^{\ast} } \times \omega_4 \\\\[10pt] 
\end{align} 
$$

<!--  
0 = & \omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\\\[10pt]
-->


### IM2

$$
\begin{align}
0 = & C(r, z) \times ( \frac{ -D_m }{ L_m^{\ast} } \times ( \omega_6 - \iota \times W  ) + \frac{1}{\gamma_m}) \\\\[10pt]  
& C(r, z - 1) \times ( \frac{ D_i }{ L_i^{\ast} } (\omega_3 - \iota \times W) - \frac{1}{\gamma_i} ) \\\\[10pt] 
& C(r, z - 2) \times \frac{ D_i }{ L_i^{\ast} } \times \omega_2 \\\\[10pt] 
& C(r, z - 3) \times \frac{ D_i }{ L_i^{\ast} } \times \omega_1 \\\\[10pt] 
& C(r, z + 1) \times \frac{ -D_m }{ L_m^{\ast} } \times \omega_5 \\\\[10pt] 
& C(r, z + 2) \times \frac{ -D_m }{ L_m^{\ast} } \times \omega_4 \\\\[10pt] 
\end{align} 
$$


