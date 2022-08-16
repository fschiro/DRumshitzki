# Equations on The Grid Interior

$$
\begin{align}
& h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& P_{erj} = \frac{f_j U_j^{\ast} r_f^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& P_{ezj} = \frac{f_j W_j^{\ast} L_j^{\ast}}{\gamma_j D_j^{\ast}} \\\\[10pt]
& h_j, f_j, \gamma_j, D_j^{\ast}, r_f^{\ast}, L_j^{\ast} \text{ are region-specific constants} \\\\[10pt]
& U^{\ast}, W^{\ast} \text{ are the dimensional velocities in r and z directions } \\\\[10pt]
& r_f^{\ast}, L_j^{\ast} \text{ are region thickness and finestral pore radii } \\\\[10pt]
& h_j = \frac{L_j^{\ast}}{r_f^{\ast}} \\\\[10pt]
\end{align}
$$
  
Note: In Shripad 2020, $D_j^{\ast} = D_j$. Glossary states $D_j$ is the effective diffusivity of albumim in region j. First paragraph of section 2.3 also states  $D_j^{\ast}$ is the effective diffusivity of albumim in region j

## Equation Transformation  

Where, below, $U_j$ and $W_j$ are the dimensionless velocity in $r, j$ respectivly.   

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

Similarly,  

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
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) - \frac{\partial^2 C_j}{\partial z_j^2} = 0
\end{align}
$$ 

## Discritization 

$$
\begin{align}
0 = & \iota \times h_j^2 \times U(r, z) ( \gamma_1 C(r-1) + \gamma_2 C(r) + \gamma_3 C(r + 1) ) + \iota \times W(r, z) ( \gamma_4 C(z-1) + \gamma_5 C(z) + \gamma_6 C(z + 1) ) \\\\[10pt]  
& - h_j^2 ( \beta_1 C(r - 1) + \beta_2 C(r) + \beta_3 C(r + 1) + \frac{1}{r} (\gamma_1 C(r - 1) + \gamma_2 C(r) + \gamma_3 C(r + 1) ) ) \\\\[10pt]  
& - ( \beta_4 C(z - 1) + \beta_5 C(z) + \beta_6 C(z + 1) )
\end{align}
$$

### Final Form  

$$
\begin{align}
0 = & C(r-1) ( \iota U h^2 \gamma_1 - h^2 \beta_1 - \frac{h^2}{r} \gamma_1 )  \\\\[10pt]  
& C(r, z) ( \iota U h^2 \gamma_2 + \iota W \gamma_5 - h^2 \beta_2 - \frac{h^2}{r} \gamma_2 - \beta_5 )  \\\\[10pt]  
& C(r + 1) ( \iota U h^2 \gamma_3 - h^2 \beta_3 - \frac{h^2}{r} \gamma_3 )  \\\\[10pt]  
& C(z - 1) ( \iota W \gamma_4 - \beta_4 )  \\\\[10pt]  
& C(z + 1) ( \iota W \gamma_6 - \beta_6)
\end{align} 
$$

Above, $U, W$ represent $U(r, z)$ and $W(r, z)$
