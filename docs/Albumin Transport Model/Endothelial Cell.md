# Endothelial Cell

There are two rows in the grid for this boundary.

Grid:   
1. Glycocalx interior end  
2. Gx-EC boundary (EC1)  
3. EC-Intima boundary (EC2)  
4. Intima interior start  
 
For derivatives we are using one-sided second-order difference at the boundary.


## Equations

Equation (18) from Shripad 2020

$$
\begin{align}
& \frac{\partial C_j}{\partial z_j} - P_{ezj} C_j = \frac{PE_{ec} L^{\ast}_j}{D^{\ast}_j} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) \\\\[10pt]
\end{align}
$$

Where:   

$$
\begin{align}
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j^{\ast}, r_f^{\ast}, L_j^{\ast}, PE_{ec}, PE_{nj} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are the dimensional velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
& U_j^{\ast} = U_j \times \frac{Kp_j}{\mu}\frac{P_l^{\ast}}{r_f^{\ast}} \text{ From Shripad} \\\\[10pt]
& W_j^{\ast} = W_j \times \frac{Kp_j}{\mu}\frac{P_l^{\ast}}{L_j^{\ast}} \text{ From Shripad} \\\\[10pt]
\end{align}
$$

## Transforming The Equations

As shown in (link to interior grid equations), the discretization of the interior equation is as follows: 

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

Plugging $\iota$ into the interior equation:  

$$
\begin{align}
& \frac{\partial C_j}{\partial z_j} - P_{ezj} C_j = \frac{PE_{ec} L^{\ast}_j}{D^{\ast}_j} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) \\\\[10pt]
& \frac{\partial C_j}{\partial z_j} - W_j \times \iota \times C_j = \frac{PE_{ec} L^{\ast}_j}{D^{\ast}_j} ( \frac{c_g}{\gamma_g} - \frac{c_i}{\gamma_i}) \\\\[10pt]
\end{align}
$$

# Discretization

### EC1
  
At EC1, $\kappa_g = \kappa(r, z-1)$ and $\kappa_i = \kappa(r, z+2)$. Then,    

$$
\begin{align}
0 = & C(r, z) \times (\omega_6 - W_j \times \iota)  \\\\[10pt]  
& C(r, z - 1) \times (\omega_5 - \frac{PE_{ec} L^{\ast}_j }{ D^{ \ast }_j \times \gamma_g} ) \\\\[10pt] 
& C(r, z - 2) \times \omega_4 \\\\[10pt] 
& C(r, z + 2) \times \frac{PE_{ec} L^{ \ast }_j }{D^{ \ast }_j \times \gamma_i} 
\end{align} 
$$

<!--  
0 = & \omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\\\[10pt]
-->


### EC2

At EC2, $\kappa_g = \kappa(r, z-2)$ and $\kappa_i = \kappa(r, z+1)$. Then,  

$$
\begin{align}
0 = & C(r, z) \times (\omega_3 - W_j \times \iota)  \\\\[10pt]  
& C(r, z + 1) \times (\omega_2 + \frac{PE_{ec} L^{\ast}_j}{D^{\ast}_j \times \gamma_i} ) \\\\[10pt] 
& C(r, z + 2) \times \omega_1 \\\\[10pt] 
& C(r, z - 2) \times \frac{-PE_{ec} L^{\ast}_j}{D^{\ast}_j \times \gamma_g} \\\\[10pt] 
\end{align} 
$$


