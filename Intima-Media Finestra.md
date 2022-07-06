# Intima-Media Boundary

## Equations

At the finestral hole on the intima-media boundary: 
 - The pressure of the intima equals the pressure of the media
 - The change in pressure is proportional

Mathematically: 
```math
\begin{align}
&P(r, z = i) = P(r, z = m) \\[10pt]
&W_i = W_m \\[10pt] 
\end{align} 
```

## Transforming The Equations

### 1. $W_j$  

$W_j$ is dimensionless velocity in Z direction for region j. $K_{pj}$ is the Darcey Permeability of region j.

```math
\begin{align}
&W_j = \frac{-K_{P_j}}{\mu} \frac{\partial P}{\partial z} \\[10pt]
&W_i = W_m \\[10pt]
&\frac{-K_{P_i}}{\mu}\frac{\partial P(r. z = i)}{\partial z}  = \frac{-K_{P_m}}{\mu} \frac{\partial P(r. z = m)}{\partial z} \\[10pt]
&K_{P_i}\frac{\partial P(r, z = i)}{\partial z}  = K_{P_m} \frac{\partial P(r, z = m)}{\partial z} \\[10pt]
\end{align} 
```

### 2. Final Equation

```math
\begin{align}
&P(r, z = i) = P(r, z = m)\\[10pt] 
&K_{P_i} \frac{\partial P(r, z = i)}{\partial z}  - K_{P_m} \frac{\partial P(r, z = m)}{\partial z} = 0
\end{align}
```

# Discritization

Assume $dZ_i = dZ_m$, so that $dz$ cancels out of equation for convienience. 

### Case 1 (Inner 1-Sided Derivatives)

### Intima Side of Boundary

```math
\begin{align}
0 = &K_{P_i} (P_i - P_{i-1}) - K_{P_m} (P_{i+1}-P_i) = 0 \\[10pt]
0 = &K_{P_i} (P_i - P_{i-1}) - 0 = 0 \\[10pt]
& (\text{ Above, intima pressure = media pressure } \rightarrow P_{i+1} = P_i) \\[10pt]
\end{align}
```

### Media Side of Boundary

```math
\begin{align}
0 = &K_{P_i} (P_i - P_{i-1}) - K_{P_m} (P_{i+1}-P_i) = 0 \\[10pt]
0 = &0 - K_{P_m} (P_{i+1}-P_i) = 0 \\[10pt]
& (\text{ Above, intima pressure = media pressure } \rightarrow P_{i-1} = P_i) \\[10pt]
\end{align}
```


## Case 2 (Outer 1-Sided Derivatives)

### Intima Side of Boundary

```math
\begin{align}
0 = &K_{P_i} (P_i - P_{i-1}) - K_{P_m} (P_{i+2}-P_{i+1}) = 0 \\[10pt]
0 = &K_{P_i} (P_i - P_{i-1}) - K_{P_m} (P_{i+2}-P_{i}) = 0 \\[10pt]
& (\text{ Above, intima pressure = media pressure } \rightarrow P_{i+1} = P_i) \\[10pt]
0 = &(K_{P_i} + K_{P_m})P_i  - K_{P_i} P_{i-1} + K_{P_m} P_{i+2} = 0 \\[10pt]
\end{align}
```
 
### Media Side of Boundary

```math
\begin{align}
0 = &K_{P_i} (P_{i-2} - P_{i-1}) - K_{P_m} (P_{i+1}-P_{i}) = 0 \\[10pt]
0 = &K_{P_i} (P_{i-2} - P_i) - K_{P_m} (P_{i+1}-P_{i}) = 0 \\[10pt]
& (\text{ Above, intima pressure = media pressure } \rightarrow P_{i-1} = P_i) \\[10pt]
0 = &(-K_{P_i} + K_{P_m})P_i  + K_{P_i} P_{i-2} - K_{P_m} P_{i+1} = 0 \\[10pt]
\end{align}
```

  
