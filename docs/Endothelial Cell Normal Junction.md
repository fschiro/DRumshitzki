# Endothelial Cell

There are two rows in the grid for this boundary.

Grid:   
1. Glycocalx interior end  
2. Gx-EC boundary (EC1)  
3. EC-Intima boundary (EC2)  
4. Intima interior start  
 
For derivatives we are using one-sided second-order difference at the boundary.


## Equations

Equation (6) from Shripad 2020

$$
\begin{align}
-W_{i} = & \frac{L_{p_{NJ}} \\, \mu \\, L_i^{*}}{K_{p_i}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\, \text{ @ intima} \\\\[10pt]
W_{g} = & W_{i}
\end{align} 
$$

## Transforming The Equations

### 1. $W_j$  

$W_j$ is dimensionless velocity in Z direction for region j. $K_{pj}$ is the Darcey Permeability of region j.

$$
\begin{align}
W_j = &\frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} \\\\[10pt]
\end{align}
$$

### 2. Transform First Equation

$$
\begin{align}
-\frac{-K_{P_i}}{\mu} \frac{\partial P}{\partial z} = &\frac{L_{p_{nj}}  \mu  L_i^* }{K_{p_i}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\frac{\partial P}{\partial z} = & \frac{\mu}{K_{P_i}}   \frac{L_{p_{nj}}  \mu  L_i^* }{K_{p_i}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\frac{\partial P}{\partial z} = & \frac{\mu^2}{K_{P_i}^2} L_{p_{nj}}   L_i^* [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
0 = & -\frac{\partial P}{\partial z} + \frac{\mu^2}{K_{P_i}^2} L_{p_{nj}}   L_i^* [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\text{Let } \xi_nj = &\frac{\mu^2}{K_{P_i}^2} L_{p_{nj}}   L_i^* \\\\[10pt]  
0 = & -\frac{\partial P}{\partial z} + \xi_nj [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)]
\end{align} 
$$

### 3. $W_{g} = W_{i}$

$$
\begin{align}
W_g = &\frac{-K_{P_g}}{\mu} \frac{\partial P(r, z=EC1)}{\partial z} \\\\[10pt]
W_i = &\frac{-K_{P_i}}{\mu} \frac{\partial P(r, z=EC2)}{\partial z} \\\\[10pt]
-K_{P_g} \frac{\partial P(r, z=EC1)}{\partial z} = & -K_{P_i} \frac{\partial P(r, z=EC2)}{\partial z} \\\\[10pt]
\end{align}
$$

### 4. Final Equation EC1

$$
0 = -K_{P_g} \frac{\partial P(r, z=EC1)}{\partial z} + K_{P_i} \frac{\partial P(r, z=EC2)}{\partial z} \\\\[10pt]
$$

### 4. Final Equation EC2

$$
\begin{align}
0 = & -\frac{\partial P(r, z=EC2)}{\partial z} + \xi_nj [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] + 
-K_{P_g} \frac{\partial P(r, z=EC1)}{\partial z} + K_{P_i} \frac{\partial P(r, z=EC2)}{\partial z} \\\\[10pt]
\end{align}
$$

# Discritization

### EC1

$$
\begin{align}
0 = & -K_{P_g} \frac{\partial P(r, z=EC1)}{\partial z} + K_{P_i} \frac{\partial P(r, z=EC2)}{\partial z} \\\\[10pt]
0 = & -K_{P_g} \\, ( \\, \omega_4 \\, P(r, z - 2) +  \omega_5 \\, P(r, z - 1) + \omega_6 \\, P(r, z) \\, ) + K_{P_i} \\, ( \\, \omega_1 \\, P(r, z + 3) + \omega_2 \\, P(r, z + 2) + \omega_3 \\, P(r, z + 1) \\, )
\end{align}
$$


### EC2

$$
\begin{align}
0 = & -K_{P_g} \frac{\partial P(r, z=EC1)}{\partial z} + K_{P_i} \frac{\partial P(r, z=EC2)}{\partial z} 
-\frac{\partial P(r, z=EC2)}{\partial z} + \xi_nj [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] 
\\\\[10pt]
0 = & -K_{P_g} \\, ( \\, \omega_4 \\, P(r, z - 3) +  \omega_5 \\, P(r, z - 2) + \omega_6 \\, P(r, z - 1) \\, ) + K_{P_i} \\, ( \\, \omega_1 \\, P(r, z + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\, )
\\\\[10pt]
& - ( \omega_1 \\, P(r, z + 2) + (\omega_2 - \xi_nj) \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\, ) + \xi_nj \\, [ \\, P(r, z-2) - P(r, z + 1) - \sigma_{EC}( \\, \pi(r, z-2) - \pi(r, z+1) \\,) \\,] 
\\\\[10pt]
0 = & 
P(r, z - 3) (-K_{P_g} \omega_4) + 
P(r, z - 2) (-K_{P_g} \omega_5 + \xi_nj) + 
P(r, z - 1) (-K_{P_g} \omega_6) + 
P(r, z) (K_{P_i} \omega_3 - \omega_3) + 
\\\\[10pt] & 
P(r, z + 1) (K_{P_i} \omega_2 + (-\omega_2 + \xi_nj) -\xi_nj) + 
P(r, z + 2) (K_{P_i} \omega_1 - \omega_1) + 
\pi(r, z-2) (-\sigma_{EC} * \xi_nj) +
\pi(r, z+1) (\sigma_{EC} * \xi_nj)
\end{align}
$$
