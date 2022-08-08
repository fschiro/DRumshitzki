# Equations on The Grid Interior

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j, r_f^{\ast}, L_j^{\ast} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
\end{align}
$$

## Equation Transformation  
Let $h_j^2 * P_{erj} = \iota_1 * U^{\ast}$ and $P_{ezj} = \iota_2 * W^{\ast}$, then:
$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& \iota_1 * U^{\ast} \frac{\partial C_j}{\partial r} +  \iota_2 * W^{\ast} \frac{\partial C_j}{\partial z} - 
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) - \frac{\partial^2 C_j}{\partial z_j^2} = 0
\end{align}
$$ 
## Discritization 

$$
\begin{align}
0 = & h^2 * [ \\\\[10pt]
& \quad \quad \beta_1 * P(r - Hb, z) +  \beta_2 * P(r, z) +  \beta_3 * P(r + Hf, z) + \\\\[10pt]
& \quad \quad \frac{1}{r} \qquad ( \qquad \gamma_1 * P(r - Hb, z) + \gamma_2 * P(r, z)  + \gamma_3 * P(r + Hf, z) \qquad ) \\\\[10pt]
&] + \beta_4 * P(r, z - Hb) +  \beta_5 * P(r, z) +  \beta_6 * P(r, z + Hf) \\\\[10pt]
\end{align}
$$

### Final Form  

$$
\begin{align}
0 = & P(r - Hb, z) \times h^2 (\beta_1 + \frac{1}{r} \gamma_1) +  
P(r, z) \times [h^2 (\beta_2  + \frac{1}{r} \gamma_2 ) + \beta_5 ] + 
P(r + Hf, z) \times h^2 (\beta_3 + \frac{1}{r} \gamma_3) + \\\\[10pt]
& P(r, z - Hb) \beta_4 +
P(r, z + Hf) \beta_6
\end{align} 
$$

