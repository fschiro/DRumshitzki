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

## Transforming The Equations

### 1. Zero Derivative Condition

The first pressure derivative on this boundary in Z-direction is one sided.


In your second-order difference derivation there are two versions: 
V1: f’(x) = A f(x + h1 + h2) + B f(x + h1) + C f(x)
V2: f’(x) = D f(x - h1 - h2) + E f(x - h1) + F f(x)

So, assuming positive Z is down, do I:
Case 1: 
Use V2 at intima-media boundary 1
Use V1 at intima-media boundary 2



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
