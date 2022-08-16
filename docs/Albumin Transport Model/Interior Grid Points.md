# Equations on The Grid Interior

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j^{\ast}, r_f^{\ast}, L_j^{\ast} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
\end{align}
$$
  
Note: In Shripad 2020, $D_j^{\ast} = D_j$. Glossary states $D_j$ is the effective diffusivity of albumim in region j. First paragraph of section 2.3 also states  $D_j^{\ast}$ is the effective diffusivity of albumim in region j

## Equation Transformation  

Define $\iota_1$:  

$$
\begin{align}
&P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
&U_j = \frac{U_j^{\ast}}{\frac{Kp_j}{\mu} \frac{Pl^{\ast}}{r_f^{\ast}}} \\\\[10pt]
&U_j^{\ast} = U_j \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{r_f^{\ast}} \\\\[10pt]
&P_{erj} =  \frac{f_j r_f^{\ast}}{\gamma_j D_j^{\ast}} \times U_j \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{r_f^{\ast}}  \\\\[10pt]
&\iota_1 =  U_j \frac{f_j r_f^{\ast}}{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{r_f^{\ast}} \\\\[10pt]
&=  U_j \frac{f_j Pl^{\ast}}{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu}  \\\\[10pt]
\end{align}
$$ 

Define $\iota_2$:  

$$
\begin{align}
&P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
&W_j = \frac{W_j^{\ast}}{\frac{Kp_j}{\mu} \frac{Pl^{\ast}}{L_j^{\ast}}} \\\\[10pt]
&W_j^{\ast} = W_j \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{L_j^{\ast}} \\\\[10pt]
&P_{erj} =  \frac{f_j L_j^{\ast}}{\gamma_j D_j^{\ast}} \times W_j \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{L_j^{\ast}}  \\\\[10pt]
&\iota_2 =  W_j \frac{f_j L_j^{\ast}}{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu} \frac{Pl^{\ast}}{L_j^{\ast}} \\\\[10pt]
&=  W_j \frac{f_j Pl^{\ast} }{\gamma_j D_j^{\ast}} \frac{Kp_j}{\mu}  \\\\[10pt]
\end{align}
$$ 

Plugging $\iota_1$ and $iota_2$ into the interior equation:  

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& \iota_1 * U \frac{\partial C_j}{\partial r} +  \iota_2 * W \frac{\partial C_j}{\partial z} - 
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) - \frac{\partial^2 C_j}{\partial z_j^2} = 0
\end{align}
$$ 

## Discritization 

### Final Form  

