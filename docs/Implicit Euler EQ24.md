# Apply Implicit Euler to EQ24

$$
\begin{align}
& \frac{\partial C_j}{\partial t} + h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
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
& \frac{\partial C_j}{\partial t} + h_j^2 * P_{erj} \frac{\partial C_j}{\partial r} + P_{ezj} \frac{\partial C_j}{\partial z} = h_j^2
( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) + \frac{\partial^2 C_j}{\partial z_j^2} \\\\[10pt]
& \frac{\partial C_j}{\partial t} +  \iota \times (U_j h_j^2 \frac{\partial C_j}{\partial r} +  W_j \frac{\partial C_j}{\partial z}) - 
h_j^2( \frac{\partial^2 C_j}{\partial r^2} + \frac{1}{r} \frac{\partial C_j}{\partial r}) - \frac{\partial^2 C_j}{\partial z_j^2} = 0
\end{align}
$$ 

## Applying implicit Euler

WLOG let $C_2 = C(t = t_i + 1)_j$

$$
\begin{align}
& \frac{C_2 - C_1}{t_2 - t_1} +  \iota \times (U_j h_j^2 \frac{\partial C_2}{\partial r} +  W_j \frac{\partial C_2}{\partial z}) - 
h_j^2( \frac{\partial^2 C_2}{\partial r^2} + \frac{1}{r} \frac{\partial C_2}{\partial r}) - \frac{\partial^2 C_2}{\partial z_j^2} = 0 \\\\[10pt]
& C_2 - C_1 + (t_2 - t_1) [
  \iota \times (U_j h_j^2 \frac{\partial C_2}{\partial r} +  W_j \frac{\partial C_2}{\partial z}) - 
  h_j^2( \frac{\partial^2 C_2}{\partial r^2} + \frac{1}{r} \frac{\partial C_2}{\partial r}) - \frac{\partial^2 C_2}{\partial z_j^2}
] = 0 \\\\[10pt]
\end{align}
$$ 

Our problem becomes an optimization problem  

$$
\begin{align}
Minimize \\, \\, \\, \\, & C_2 - C_1 + (t_2 - t_1) [
  \iota \times (U_j h_j^2 \frac{\partial C_2}{\partial r} +  W_j \frac{\partial C_2}{\partial z}) - 
  h_j^2( \frac{\partial^2 C_2}{\partial r^2} + \frac{1}{r} \frac{\partial C_2}{\partial r}) - \frac{\partial^2 C_2}{\partial z_j^2}
] \\\\[10pt]
S.T. \\, \\, \\, \\,  & C_2 \geq 0
\end{align}
$$ 

## Discritization 
  
Let

$$
\frac{\partial C_2}{\partial r} = A_1 C_2 + B_1 \\\\[10pt]
\frac{\partial C_2}{\partial z} = A_2 C_2 + B_2  \\\\[10pt]
\frac{\partial^2 C_2}{\partial r^2} = A_3 C_2 + B_3  \\\\[10pt]
\frac{\partial^2 C_2}{\partial z_j^2} = A_4 C_2 + B_4  \\\\[10pt]
$$  

Then the equation becomes

$$
\begin{align}
& C_2 - C_1 + (t_2 - t_1) [
  \iota \times (U_j h_j^2 (A_1 C_2 + B_1) +  W_j (A_2 C_2 + B_2)) - 
  h_j^2( (A_3 C_2 + B_3) + \frac{1}{r} (A_3 C_2 + B_3)) - (A_4 C_2 + B_4)
]
\end{align}
$$ 



