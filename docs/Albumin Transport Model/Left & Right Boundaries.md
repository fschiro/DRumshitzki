# Summary 

At the boundaries in R we have the interior equation and two additional conditions. Axisymmetry and zero change in pressure at the boundaries.

# Equations

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& 0 = \frac{\partial C}{\partial r} \\\\[10pt]
& C(0, z) = C(r=max, z) \\\\[10pt]
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

## Discritization 

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
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& \iota \times (U_j h_j^2 \frac{\partial C_j}{\partial r} +  W_j \frac{\partial C_j}{\partial z}) - 
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) - \frac{\partial^2 C_j}{\partial z_j^2} = 0 \\\\[10pt]
& \iota \times (U_j h_j^2 * 0 +  W_j \frac{\partial C_j}{\partial z}) - 
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} * 0) - \frac{\partial^2 C_j}{\partial z_j^2} = 0 \\\\[10pt]
& \iota \times W_j \frac{\partial C_j}{\partial z} - h_j^2 \frac{\partial^2 C_j}{\partial r^2} - \frac{\partial^2 C_j}{\partial z_j^2} = 0 \\\\[10pt]
\end{align}
$$ 

This becomes:  

$$
\begin{align}
& \iota \times W_j \times ( \gamma_4 C(r, z-1) + \gamma_5 C(r, z) + \gamma_6 C(r, Z+1) ) \\\\[10pt]
& - h_j^2 ( \beta_1 C(r-1, z) + \beta_2 C(r, z) + \beta_3 C(r+1, z) ) \\\\[10pt]
& - ( \beta_4 C(r, z-1) + \beta_5 C(r, z) + \beta_6 C(r, z+1) )
\end{align}
$$  

Above, at the left boundary $C(r-1, z) = C(r_max, z)$ and at the right boundary $C(r + 1, z) = C(r=0, z)$.  
Because these are not in the grid/matrix, in the matrix these elements are not updated. These need to be entered into B-vector to form $Ax+b=0$. 

## Final Form of Left boundary

### Matrix  

$$
\begin{align}
0 = & C(r, z) \times ( \iota \times W_j \times \gamma_5 - h_j^2 \times \beta_2 - \beta_5) +  \\\\[10pt]
& C(r, z - 1) \times ( \iota \times W_j \times \gamma_4 - \beta_4) + \\\\[10pt]
& C(r, z + 1) \times ( \iota \times W_j \times \gamma_6 - \beta_6) -  \\\\[10pt]
& C(r - 1, z) \times -1 \times h_j^2 \times \beta_1  \\\\[10pt]
& C(r + 1, z) \times -1 \times h_j^2 \times \beta_3  \\\\[10pt]
\end{align} 
$$


## Vector   

All points on boundary need $h_j^2 \beta_1$ added to boundary-vector.


## Final Form of Right boundary

### Matrix  


$$
\begin{align}
0 = & C(r, z) \times ( \iota \times W_j \times \gamma_5 - h_j^2 \times \beta_2 - \beta_5) +  \\\\[10pt]
& C(r, z - 1) \times ( \iota \times W_j \times \gamma_4 - \beta_4) + \\\\[10pt]
& C(r, z + 1) \times ( \iota \times W_j \times \gamma_6 - \beta_6) -  \\\\[10pt]
& C(r - 1, z) \times -1 \times h_j^2 \times \beta_1  \\\\[10pt]
& C(r + 1, z) \times -1 \times h_j^2 \times \beta_3  \\\\[10pt]
\end{align} 
$$


## Vector   

All points on boundary need $-h_j^2 \beta_3$ added to boundary-vector.
