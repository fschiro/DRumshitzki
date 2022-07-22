# Summary 

At the top and bottom boundaries in z we have the following conditions:
Interior equation
Pressure at the top of Glycocalx = 1
Pressure at bottom of Media = 0

Note: We don't need to modify the pressure matrix because no changes to the interior equation. We need to modify the boundary-vector for the top (GX) boundary. The bottom (Media) boundary-vector values do not need to be modified because the pressure is zero, the boundary-vector default value. 

# Equations on The Grid Interior

$$
\begin{align}
& 0 = h^2 * ( \frac{\partial^2 P}{\partial r^2} + \frac{1}{r} \frac{\partial P}{\partial r}) + \frac{\partial^2 P}{\partial z}\\\\[10pt]
& 1 = P(r, z = 0) \\\\[10pt]
& 0 = P(r, z = max) \\\\[10pt]
\end{align}
$$

## Discritization 

$$
\begin{align}
0 = & h^2 * [ \\\\[10pt]
& \quad \quad \beta_1 * P(r - Hb, z) +  \beta_2 * P(r, z) +  \beta_3 * P(r + Hf, z) + \\\\[10pt]
& \quad \quad \frac{1}{r} \qquad ( \qquad \gamma_1 * P(r - Hb, z) + \gamma_2 * P(r, z)  + \gamma_3 * P(r + Hf, z) \qquad ) \\\\[10pt]
&] + \beta_4 * P(r, z - Hb) +  \beta_5 * P(r, z) +  \beta_6 * P(r, z + Hf) \\\\[10pt]
\end{align}
$$

Above, at the top boundary $P(r, z-1) = 1$ and at the bottom boundary $P(r, z+1) = 0$.  
Because these are not in the grid/matrix, in the matrix these elements are not updated. These need to be entered into the boundary-vector. 

## Final Form of top boundary

### Matrix  

$$
\begin{align}
0 = &  P(r - Hb, z) \times h^2 \beta_1 + \frac{1}{r} \gamma_1 + 
P(r, z) \times [ h^2 (\beta_2 + \frac{1}{r} \gamma_2) + \beta_5 ] +
P(r + Hf, z) \times h^2(\beta_3 + \frac{1}{r} \gamma_3)  + 
P(r, z + Hf) \beta_6
\end{align} 
$$


### Vector   

All points on boundary need $\beta_4$ added to boundary-vector. The pressure $= 1\rightarrow 1 \times \beta_4 = \beta_4$


## Final Form of Right boundary

### Matrix  

$$
\begin{align}
0 = &  P(r - Hb, z) \times h^2 \beta_1 + \frac{1}{r} \gamma_1 + 
P(r, z) \times [ h^2 (\beta_2 + \frac{1}{r} \gamma_2) + \beta_5 ]+
P(r + Hf, z) \times h^2(\beta_3 + \frac{1}{r} \gamma_3)  + 
P(r, z - Hb) \beta_4 
\end{align} 
$$


### Vector   

We don't need to modify the boundary. The value of pressure here is zero which is the default value of boundary-vector. 

