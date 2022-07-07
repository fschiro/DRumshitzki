# Intima-Media Boundary - Non-Finestra

There are two rows in the grid for this boundary.

Grid: 
 Intima interior end
 Intima-media boundary 1
 Intima-media boundary 2
 Media interior start
 
We use one-sided second-order differences here, and these differences not cross the boundary. 

## Equations

At the finestral hole on the intima-media boundary: 
 - Change in pressure is zero in Z-direction since finestral hole changed with barrier

Mathematically: 

$$
\begin{align}
&\frac{\partial P_j}{\partial Z_j} = 0 \\, \\, j \in  \\{m, i \\} \\
\end{align} 
$$

## Discritization 

$$
\begin{align}
&\frac{\partial P}{\partial z}  =  \omega_4 * P(r, z - h_1 - h_2) +  \omega_5 * P(r, z - h_1) +  \omega_6 * P(r, z) = 0 \text{ @ Intima} \\  
&\frac{\partial P}{\partial z}  =  \omega_1 * P(r, z + h_1 + h_2) +  \omega_2 * P(r, z + h_1) +  \omega_3 * P(r, z) = 0 \text{ @ Media} \\  
\end{align} 
$$

## B-Vector

No B-vector additions because every point adjacnet to intima-media boundary is in the grid interior, and, no r derivatives so no boundaries on left or right sides. 
