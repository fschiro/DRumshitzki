# Endothelial Cell

There are two rows in the grid for this boundary.

Grid:   
1. Glycocalx interior end  
2. Gx-EC boundary (EC1)  
3. EC-Intima boundary (EC2)  
4. Intima interior start  
 
For derivatives we are using one-sided second-order difference at the boundary.


## Equations

Equation (19, 20) from Shripad 2020

$$
\begin{align}
& \frac{\partial C_i}{\partial z_i} - P_{ezi} C_i = \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) - \frac{W_i^{\ast} L_i^{\ast}}{D_i^{\ast}} (1 - \sigma_{nj} ) \bar{C} \\\\[10pt]
&\frac{ D_g^{\ast} }{ L_g^{\ast} }( \frac{\partial C_g}{\partial z_g} - P_{ezg}C_g) = \frac{ D_i^{\ast} }{ L_i^{\ast} } (\frac{\partial C_i}{\partial z_i} -  P_{ezi}C_i))
\end{align}
$$

Where:   

$$
\begin{align}
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j^{\ast}, r_f^{\ast}, L_j^{\ast}, PE_{ec}, PE_{nj}, \sigma_{nj}, \sigma_{EC} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are the dimensional velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
& U_j^{\ast} = U_j \times \frac{Kp_j}{\mu}\frac{P_l^{\ast}}{r_f^{\ast}} \text{ From Shripad} \\\\[10pt]
& W_j^{\ast} = W_j \times \frac{Kp_j}{\mu}\frac{P_l^{\ast}}{L_j^{\ast}} \text{ From Shripad} \\\\[10pt]
\end{align}
$$

## Transforming The Equations

As shown in (link to interior grid equations), the discritization of the interior equation is as follows: 

Let $\iota = \frac{f_j Pl^{\ast} }{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu} $  
Then, 

$$
\begin{align}
P_{erj} & = \frac{f_j r_f^{\ast}}{\gamma_j D_j^{\ast}} \times U_j^{\ast} \\\\[10pt]
& = \frac{f_j r_f^{\ast}}{\gamma_j D_j^{\ast}} \times \frac{Kp_j}{\mu}\frac{P_l^{\ast}}{r_f^{\ast}} \times U_j \\\\[10pt]
& = \frac{f_j P_l^{\ast}}{\gamma_j D_j^{\ast}} \times \frac{Kp_j}{\mu} \times U_j \\\\[10pt]
& = \iota \times U_j \\\\[10pt]
\end{align}
$$

WLOG,  

$$
\begin{align}
P_{erj} = & U_j \times \iota   \\\\[10pt]
P_{ezj} = & W_j \times \iota   \\\\[10pt]
\end{align}
$$ 

Plugging $\iota$ into equations 19:  

$$
\begin{align}
& \frac{\partial C_i}{\partial z_i} - P_{ezi} C_i = \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) - \frac{W_i^{\ast} L_i^{\ast}}{D_i^{\ast}} (1 - \sigma_{nj} ) \bar{C} \\\\[10pt]
& \frac{\partial C_i}{\partial z_i} - W_i \times \iota C_i = \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) - \frac{W_i K_{pi}}{\mu} \frac{P_l^{\ast}}{L_i^{\ast}}\frac{ L_i^{\ast}}{D_i^{\ast}} (1 - \sigma_{nj} ) \bar{C} \\\\[10pt]
& \frac{\partial C_i}{\partial z_i} - W_i \times \iota C_i = \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) - W_i \times \iota \times \frac{\gamma_i}{f_i} (1 - \sigma_{nj} ) \bar{C} \\\\[10pt]
& \frac{\partial C_i}{\partial z_i} + W_i \times \iota (-C_i + \frac{\gamma_i}{f_i} (1 - \sigma_{nj} ) \bar{C}) - \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i})
\end{align}
$$

Plugging $\iota$ into equations 19:    

$$
\begin{align}
&\frac{ D_g^{\ast} }{ L_g^{\ast} }( \frac{\partial C_g}{\partial z_g} - P_{ezg}C_g) = \frac{ D_i^{\ast} }{ L_i^{\ast} } (\frac{\partial C_i}{\partial z_i} -  P_{ezi}C_i)) \\\\[10pt]
&\frac{ D_g^{\ast} }{ L_g^{\ast} }( \frac{\partial C_g}{\partial z_g} - \iota \times W_g C_g) = \frac{ D_i^{\ast} }{ L_i^{\ast} } (\frac{\partial C_i}{\partial z_i} -  \iota \times W_i C_i)) \\\\[10pt]
\end{align}
$$

Combining equations 19 and 20:    

$$
\begin{align}
& \frac{\partial C_j}{\partial z_j} + W_j \times \iota (-C_j + \frac{\gamma_j}{f_j} (1 - \sigma_{nj} ) \bar{C}) - \frac{PE_{nj} L^{\ast}_i}{D^{\ast}_i} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) + 
\frac{ D_g^{\ast} }{ L_g^{\ast} }( \frac{\partial C_g}{\partial z_g} - \iota \times W_g C_g) - \frac{ D_i^{\ast} }{ L_i^{\ast} } (\frac{\partial C_i}{\partial z_i} -  \iota \times W_i C_i)) = 0
\end{align}
$$

# Discritization

### EC1

At EC1, $\kappa_g = \kappa(r, z-1)$ and $\kappa_i = \kappa(r, z+2)$. Then,  

$$
\begin{align}
0 = &C_j \omega_6 + C_{j-1} \omega_5 + C_{j-2} \omega_4 - W_j \iota C_j + W_j \iota \frac{\gamma_j}{f_j} (1 -\sigma_{nj}) \bar{C} \\\\[10pt]
& - \frac{PE_{nj} L_j^{\ast}}{D_j^{\ast}} ( \frac{C_{j-1}}{\gamma_g} - \frac{C_{j+2}}{\gamma_i} ) \\\\[10pt]
& + \frac{D_g^{\ast}}{L_g^{\ast}}( C_{j-1} \omega_6 + C_{j-2} \omega_5 + C_{j-3} \omega_4 - \iota W_{j-1} C_{j-1})  \\\\[10pt]
& - \frac{D_i^{\ast}}{L_i^{\ast}}( C_{j+2} \omega_3 + C_{j+3} \omega_2 + C_{j+4} \omega_1 - \iota W_{j+2} C_{j+2})  \\\\[10pt]
\end{align} 
$$  

This becomes:  

$$
\begin{align}
0 = & C(r, z) \times ( \omega_6 - W_j \iota ) +   \\\\[10pt]
& C(r, z - 1) \times ( \omega_5 - \frac{PE_{nj} L_j^{\ast}}{D_j^{\ast} \gamma_g} + \frac{D_g^{\ast}}{L_g^{\ast}} \omega_6 - \frac{D_g^{\ast}}{L_g^{\ast}} \iota W_{j-1} ) +   \\\\[10pt]
& C(r, z - 2) \times ( \omega_4  + \frac{D_g^{\ast}}{L_g^{\ast}} \omega_5 ) +   \\\\[10pt]
& C(r, z - 3) \times (  + \frac{D_g^{\ast}}{L_g^{\ast}} \omega_4 ) +   \\\\[10pt]
& C(r, z + 1) \times ( ) +   \\\\[10pt]
& C(r, z + 2) \times ( - \frac{PE_{nj} L_j^{\ast}}{D_j^{\ast} \gamma_i} - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_3 + \frac{D_i^{\ast}}{L_i^{\ast}} \iota W_{j+2} ) +   \\\\[10pt]
& C(r, z + 3) \times ( - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_2 ) +   \\\\[10pt]
& C(r, z + 4) \times ( - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_1 ) +  \\\\[10pt]
& W_j \iota \frac{\gamma_j}{f_j} (1 -\sigma_{nj}) \bar{C}  \\\\[10pt]
\end{align} 
$$



### EC2

At EC1, $\kappa_g = \kappa(r, z-2)$ and $\kappa_i = \kappa(r, z+1)$. Then,  

$$
\begin{align}
0 = & C_j \omega_3 + C_{j+1} \omega_2 + C_{j+2} \omega_1 - W_j \iota C_j + W_j \iota \frac{\gamma_j}{f_j} (1 -\sigma_{nj}) \bar{C} \\\\[10pt]
& - \frac{PE_{nj} L_j^{\ast}}{D_j^{\ast}} ( \frac{C_{j-2}}{\gamma_g} - \frac{C_{j+1}}{\gamma_i} ) \\\\[10pt]
& + \frac{D_g^{\ast}}{L_g^{\ast}}( C_{j-2} \omega_6 + C_{j-3} \omega_5 + C_{j-4} \omega_4 - \iota W_{j-2} C_{j-2})  \\\\[10pt]
& - \frac{D_i^{\ast}}{L_i^{\ast}}( C_{j+1} \omega_3 + C_{j+2} \omega_2 + C_{j+3} \omega_1 - \iota W_{j+1} C_{j+1})  \\\\[10pt]
\end{align} 
$$  

$$
\begin{align}
0 = & C(r, z) \times ( \omega_3 - W_j \iota ) + \\\\[10pt]
& C(r, z - 1) \times (  ) + \\\\[10pt]
& C(r, z - 2) \times ( - \frac{PE_{nj} L_j^{\ast}}{D_j^{\ast} \gamma_g } + \frac{D_g^{\ast}}{L_g^{\ast}} \omega_6 - \frac{D_g^{\ast}}{L_g^{\ast}} \iota W_{j-2} ) + \\\\[10pt]
& C(r, z - 3) \times ( \frac{D_g^{\ast}}{L_g^{\ast}} \omega_5 ) + \\\\[10pt]
& C(r, z - 3) \times (\frac{D_g^{\ast}}{L_g^{\ast}} \omega_4 ) + \\\\[10pt]
& C(r, z + 1) \times ( \omega_2 + frac{PE_{nj} L_j^{\ast}}{D_j^{\ast} \gamma_i } - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_3 + \frac{D_i^{\ast}}{L_i^{\ast}}  \iota W_{j+1}  ) + \\\\[10pt]
& C(r, z + 2) \times ( \omega_1 - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_2 ) + \\\\[10pt]
& C(r, z + 3) \times ( - \frac{D_i^{\ast}}{L_i^{\ast}} \omega_1 ) + \\\\[10pt]
& C(r, z + 4) \times (  ) + \\\\[10pt]
& W_j \iota \frac{\gamma_j}{f_j} (1 -\sigma_{nj}) \bar{C}  \\\\[10pt]
\end{align} 
$$
