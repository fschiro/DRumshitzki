# Intima-Media Boundary @ Finestra


There are two rows in the grid for this boundary.

Grid:   
1. Intima interior end  
2. Intima-media boundary 1 (IM1)  
3. Intima-media boundary 2 (IM2)  
4. Media interior start  
 
For derivatives we are using one-sided second-order difference at the boundary.

## Equations

At the finestral hole on the intima-media boundary: 
 - The pressure of the intima equals the pressure of the media
 - The change in pressure is proportional

Mathematically: 

$$
\begin{align}
&P(r, z = IM1) = P(r, z = IM2) \\\\[10pt]
&W_i = W_m \\  
\end{align} 
$$

## Transforming The Equations

### 1. $W_j$  

$W_j$ is dimensionless velocity in Z direction for region j. $K_{pj}$ is the Darcey Permeability of region j.

$$
\begin{align}
&W_j = \frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} \\\\[10pt]
&W_i = W_m \\\\[10pt]
&\frac{-K_{P_i}}{\mu}\frac{\partial P(r, z = IM1}{\partial z}  = \frac{-K_{P_m}}{\mu} \frac{\partial P(r,z = IM2)}{\partial z} \\\\[10pt]
&K_{P_i}\frac{\partial P(r, z = IM1}{\partial z}  = K_{P_m} \frac{\partial P(r, z = IM2)}{\partial z} \\\\[10pt]
\end{align} 
$$

### 2. Final Equation

$$
\begin{align}
&P(r, z = IM1) = P(r, z = IM2) \\\\[10pt]
&K_{P_i} \frac{\partial P(r, z = IM1}{\partial z}  - K_{P_m} \frac{\partial P(r, z = IM2)}{\partial z} = 0
\end{align}
$$

# Discritization

### Intima Side of Boundary

$$
\begin{align}
0 = &K_{P_i} \\, ( \omega_4 \\, P(r, z - 1 - 2) +  \omega_5 \\, P(r, z - 1) + \omega_6 \\, P(r, z) ) - K_{P_m} \\, (\omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) ) = 0 \\\\[10pt]
= & K_{P_i} \\, \omega_4 \\, P(r, z - 1 - 2) + K_{P_i} \\, \omega_5 P(r, z - 1) + (K_{P_i} \\, \omega_6 + K_{P_m} \\, \omega_3) \\, P(r, z) + K_{P_m} \\, \omega_2 \\, P(r, z + 1) + K_{P_m} \\, \omega_1 \\, P(r, z + 1 + 2) \\\\[10pt]
= & K_{P_i} \\, \omega_4 \\, P(r, z - 1 - 2) + K_{P_i} \\, \omega_5 \\, P(r, z - 1) + (K_{P_i} \\, \omega_6 + K_{P_m} \\, \omega_3 + K_{P_m} \\, \omega_2) \\, P(r, z) + K_{P_m} \\, \omega_1 \\, P(r, z + 1 + 2) \\\\[10pt]
\end{align}
$$

Above, $P(r, z) = P(r, z+1)$ since pressure at IM1 = pressure at IM2

### Media Side of Boundary

$$
\begin{align}
0 = & K_{P_i} \\, ( \omega_4 \\, P(r, z - 1 - 2) +  \omega_5 \\, P(r, z - 1) +  \omega_6 \\, P(r, z) ) - K_{P_m} \\, (\omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z)) = 0 \\\\[10pt]
= & K_{P_i} \\, \omega_4 \\, P(r, z - 1 - 2) + K_{P_i} \\, \omega_5 \\, P(r, z - 1) + ( K_{P_i} \\, \omega_6 + K_{P_m} \\, \omega_3 ) P(r, z) + K_{P_m} \\, \omega_2 \\, P(r, z + 1) + K_{P_m} \\, \omega_1 \\, P(r, z + 1 + 2) \\\\[10pt]
= & K_{P_i} \\, \omega_4 \\, P(r, z - 1 - 2) + (K_{P_i} \\, \omega_5 + K_{P_i} \\, \omega_6 + K_{P_m} \\, \omega_3) P(r, z) + K_{P_m} \\, \omega_2 \\, P(r, z + 1) + K_{P_m} \\, \omega_1 \\, P(r, z + 1 + 2) \\\\[10pt]
\end{align}
$$

Above, $P(r, z) = P(r, z - 1)$ since pressure at IM1 = pressure at IM2


  
