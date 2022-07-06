# Discritization

## Normal Grid-Points

$$
\begin{align}
&\frac{\partial^2 P}{\partial r^2}  = \beta_1 * P(r - Hb, z) +  \beta_2 * P(r, z) +  \beta_3 * P(r + Hf, z) \\  
&\frac{\partial^2 P}{\partial z^2}  =  \beta_4 * P(r, z - Hb) +  \beta_5 * P(r, z) +  \beta_6 * P(r, z + Hf) \\  
&\frac{\partial P}{\partial r}  = \gamma_1 * P(r - Hb, z) + \gamma_2 * P(r, z)  + \gamma_3 * P(r + Hf, z) \\  
&\frac{\partial P}{\partial z}  = \gamma_4 * P(r, z - Hb) + \gamma_5 * P(r, z)  + \gamma_6 * P(r, z + Hf) \\  
\end{align} 
$$

## Intima-Media Boundary

Here, $\frac{\partial P}{\partial z}$ is one-sided into the boundary:  

$$
\begin{align}
&\text{Intima: }\frac{\partial P}{\partial z}= \frac{P(r, z) - P(r, z-1)}{dz} \\  
&\text{Media: }\frac{\partial P}{\partial z} = \frac{P(r, z+1) - P(r, z)}{dz}
\end{align}
$$

### questions

Why is derivative one-sided?
Is second derivative one-sided? $\frac{\partial^2 P}{\partial z^2}$ ?

