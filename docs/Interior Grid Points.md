# Equations on The Grid Interior

$$
\begin{align}
& h^2 * ( \frac{\partial^2 P}{\partial r^2} + \frac{1}{r} \frac{\partial P}{\partial r}) + \frac{\partial^2 P}{\partial z} = 0 \\\\[10pt]
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

### Final Form  

$$
\begin{align}
0 = & P(r - Hb, z) \times h^2 (\beta_1 + \frac{1}{r} \gamma_1) +  
P(r, z) \times h^2 (\beta_2  + \frac{1}{r} \gamma_2 + \beta_5) + 
P(r + Hf, z) \times h^2 (\beta_3 + \frac{1}{r} \gamma_3) + \\\\[10pt]
& P(r, z - Hb) \beta_4 +
P(r, z + Hf) \beta_6
\end{align} 
$$

