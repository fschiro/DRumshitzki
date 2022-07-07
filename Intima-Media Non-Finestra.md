# Intima-Media Boundary - Non-Finestra

## Equations

At the finestral hole on the intima-media boundary: 
 - Change in pressure is zero in Z-direction since finestral hole changed with barrier

Mathematically: 

$$
\begin{align}
&\frac{\partial P_j}{\partial Z_j} = 0 \\, \\, j \in  \\{m, i \\} \\
\end{align} 
$$

## Transforming The Equations

### 1. Zero Derivative Condition

The first pressure derivative on this boundary in Z-direction is one sided.

$$
\begin{align}
\frac{\partial P_i}{\partial Z} = 0  \rightarrow \frac{P_i - P_{i-1}}{\Delta Z} = 0 \rightarrow P_i = P_{i-1} * \Delta Z \text{ @ Intima} \\
\frac{\partial P_j}{\partial Z_j} = 0  \rightarrow \frac{P_i - P_{i+1}}{\Delta Z} = 0 \rightarrow P_i = P_{i+1} * \Delta Z \text{ @ Media} \\
\end{align}
$$

### 3. Final Equation

$$
\begin{align}
&P_i = P_{i-1} * \Delta Z \text{ at Intima} \\
&P_{i+1} = P_i * \Delta Z \text{ at Media} \\
\end{align}
$$

# Discritization
$$
\begin{align}
&P_i - P_{i-1} * \Delta Z \text{ at Intima} \\
&P_{i+1} - P_i * \Delta Z \text{ at Media} \\
\end{align}
$$

 ## B-Vector
No B-vector additions because the interior boundary is in the grid. 
R direction B-vector already written on left and right sides. 
