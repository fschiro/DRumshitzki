# Summary 

At the boundaries in R we have the interior equation and two additional conditions. Axisymmetry and zero change in pressure at the boundaries.

# Equations

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& C(r, 0) = \gamma_g \\\\[10pt]
& C(r, z_{max}) = \gamma_m \\\\[10pt]
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
\end{align}
$$ 

As in the interior, this becomes:  

$$
\begin{align}
0 = & C(r-1, z) ( \iota U h^2 \gamma_1 - h^2 \beta_1 - \frac{h^2}{r} \gamma_1 )  \\\\[10pt]  
& C(r, z) ( \iota U h^2 \gamma_2 + \iota W \gamma_5 - h^2 \beta_2 - \frac{h^2}{r} \gamma_2 - \beta_5 )  \\\\[10pt]  
& C(r + 1, z) ( \iota U h^2 \gamma_3 - h^2 \beta_3 - \frac{h^2}{r} \gamma_3 )  \\\\[10pt]  
& C(r, z - 1) ( \iota W \gamma_4 - \beta_4 )  \\\\[10pt]  
& C(r, z + 1) ( \iota W \gamma_6 - \beta_6)
\end{align} 
$$

## Final Form

### Matrix  

No change in matrix equations

## Vector-Top

All points on boundary need $\gamma_g \times (\iota W \gamma_4 - \beta_4)$ added to boundary-vector.

## Vector-Bottom  

All points on boundary need $\gamma_m \times (\iota W \gamma_6 - \beta_6)$ added to boundary-vector.
