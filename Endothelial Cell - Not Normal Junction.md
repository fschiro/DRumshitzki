# Endothelial Cells (Not Normal Junction)

## Equations

Equation (6) from Shripad


Mathematically: 

$$
\begin{align}
-W_j = & \frac{L_{p_{nj}}  \mu  L_j^*}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\: (j=g,i) \\  
0 = & h^2 (\frac{\partial^2 P}{\partial r^2}  + \frac{1}{r} \frac{\partial P}{\partial r} ) + \frac{\partial^2 P}{\partial z^2} 
\end{align} 
$$

## Transforming The Equations

### 1. $W_j$  

$W_j$ is dimensionless velocity in Z direction for region j. $K_{pj}$ is the Darcey Permeability of region j.

$$
\begin{align}
W_j = &\frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} \\
-\frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} = &\frac{L_{p_{nj}}  \mu  L_j^{*}}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\  
\frac{\partial P}{\partial z} = & \frac{\mu}{K_{P_j}}   \frac{L_{p_{nj}}  \mu  L_j^{*}}{K_{p_j}} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\  
\frac{\partial P}{\partial z} = & \frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\  
0 = & -\frac{\partial P}{\partial z} + \frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\  
\text{Let } \xi_j = &\frac{\mu^2}{K_{P_j}^2} L_{p_{nj}}   L_j^{*} \\  
0 = & -\frac{\partial P}{\partial z} + \xi_j [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)]
\end{align} 
$$

### 3. Final Equation

$$
\begin{align}
&\psi + \frac{\partial^2 P}{\partial z^2}  - \frac{\partial P}{\partial z} + \xi_j [P_g - P_i - \sigma_{EC}(\pi_g - \pi_i)] \\  
\end{align}
$$
