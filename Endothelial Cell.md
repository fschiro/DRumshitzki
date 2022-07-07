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
-W_j = & \frac{L_{p_{nj}} \\, \mu \\, L_j^{*}}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\: (j=g,i) \\  
\end{align} 
$$

## Transforming The Equations

### 1. $W_j$  

$W_j$ is dimensionless velocity in Z direction for region j. $K_{pj}$ is the Darcey Permeability of region j.

$$
\begin{align}
W_j = &\frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} \\\\[10pt]
-\frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} = &\frac{L_{p_{nj}}  \mu  L_j^{*}}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\frac{\partial P}{\partial z} = & \frac{\mu}{K_{P_j}}   \frac{L_{p_{nj}}  \mu  L_j^{*}}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\frac{\partial P}{\partial z} = & \frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
0 = & -\frac{\partial P}{\partial z} + \frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\\\[10pt]  
\text{Let } \xi_j = &\frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} \\\\[10pt]  
0 = & -\frac{\partial P}{\partial z} + \xi_j [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)]
\end{align} 
$$

### 3. Final Equation

$$
-\frac{\partial P}{\partial z} + \xi_j [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)]
$$



# Discritization

### EC1

$$
\begin{align}
0 = & \omega_4 \\, P(r, z - 1 - 2) +  \omega_5 \\, P(r, z - 1) + \omega_6 \\, P(r, z) + \xi_j [P(r, z - 1) - P(r, z + 2) - \sigma_{EC}(\pi(r, z-1) - \pi(r, z + 2))] \\\\[10pt]
0 = & \omega_4 \\, P(r, z - 1 - 2) +  (\omega_5 + \xi_j) \\, P(r, z - 1) + \omega_6 \\, P(r, z) + -\xi_j \\, P(r, z + 2) - \xi_j \\, \sigma_{EC} \\, \pi(r, z-1) + \xi_j \\, \sigma_{EC} \\, \pi(r, z + 2) \\\\[10pt]
\end{align}
$$

<!--  
0 = & \omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) \\\\[10pt]
-->


### EC2

$$
\begin{align}
0 = & \omega_1 \\, P(r, z + 1 + 2) + \omega_2 \\, P(r, z + 1) + \omega_3 \\, P(r, z) + \xi_j [P(r, z - 2) - P(r, z + 1) - \sigma_{EC}(\pi(r, z-2) - \pi(r, z + 1))] \\\\[10pt]
0 = & \omega_1 \\, P(r, z + 1 + 2) + (\omega_2 - \xi_j) \\, P(r, z + 1) + \omega_3 \\, P(r, z) + \xi_j \\, P(r, z - 2) - \xi_j \\, \sigma_{EC} \\, \pi(r, z-2) + \xi_j \\, \sigma_{EC} \\, \pi(r, z + 1) \\\\[10pt]
\end{align}
$$


