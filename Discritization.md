# Discritization

## Two-Sided First-Order-Differences, First and Second Derivatives:

$$
\begin{align}
&\frac{\partial^2 P}{\partial r^2}  = \beta_1 * P(r - Hb, z) +  \beta_2 * P(r, z) +  \beta_3 * P(r + Hf, z) \\  
&\frac{\partial^2 P}{\partial z^2}  =  \beta_4 * P(r, z - Hb) +  \beta_5 * P(r, z) +  \beta_6 * P(r, z + Hf) \\  
&\frac{\partial P}{\partial r}  = \gamma_1 * P(r - Hb, z) + \gamma_2 * P(r, z)  + \gamma_3 * P(r + Hf, z) \\  
&\frac{\partial P}{\partial z}  = \gamma_4 * P(r, z - Hb) + \gamma_5 * P(r, z)  + \gamma_6 * P(r, z + Hf) \\  
\end{align} 
$$

## One-Sided First-Order-Differences, First and Second Derivatives:

$$
\begin{align}
&\frac{\partial^2 P}{\partial z^2}  =  \omega_1 * P(r, z + h_1 + h_2) +  \omega_2 * P(r, z + h_1) +  \omega_3 * P(r, z) \\  
&\frac{\partial^2 P}{\partial z^2}  =  \omega_4 * P(r, z - h_1 - h_2) +  \omega_5 * P(r, z - h_1) +  \omega_6 * P(r, z) \\  
\end{align} 
$$

Above, two forms are needed because we use each on both sides of a boundary. 

$$
\begin{align}
&\omega_1 = \frac{-h_1}{h_2 ( h_1 + h_2 ) } \\  
&\omega_2 = \frac{h_1 + h_2}{h_1 h_2 ) } \\  
&\omega_3 = -\frac{2h_1 + h_2}{h_2 ( h_1 + h_2 ) } \\  
&\omega_4 = \frac{h_1}{h_2 ( h_1 + h_2 ) } \\  
&\omega_5 = -\frac{h_1 + h_2}{h_1 h_2 ) } \\  
&\omega_6 = \frac{2h_1 + h_2}{h_2 ( h_1 + h_2 ) } \\  
\end{align} 
$$
