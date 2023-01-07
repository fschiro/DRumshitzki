# Discritization

## Two-Sided First-Order-Differences, First and Second Derivatives:

$$
\begin{align}
&\frac{\partial^2 P}{\partial r^2}  = \beta_1 * P(r - Hb, z) +  \beta_2 * P(r, z) +  \beta_3 * P(r + Hf, z) \\\\[10pt]  
&\frac{\partial^2 P}{\partial z^2}  =  \beta_4 * P(r, z - Hb) +  \beta_5 * P(r, z) +  \beta_6 * P(r, z + Hf) \\\\[10pt]  
&\frac{\partial P}{\partial r}  = \gamma_1 * P(r - Hb, z) + \gamma_2 * P(r, z)  + \gamma_3 * P(r + Hf, z) \\\\[10pt]  
&\frac{\partial P}{\partial z}  = \gamma_4 * P(r, z - Hb) + \gamma_5 * P(r, z)  + \gamma_6 * P(r, z + Hf) \\\\[10pt]  
\end{align} 
$$

$$
\begin{equation}
  \begin{split}
    \beta_1 &= \frac{ 2 }{ drb * (drb + drf) } \\\\[10pt]
    \beta_4 &= \frac{ 2 }{ dzu * (dzd + dzu) } \\\\[10pt]
    \gamma_1 &= \frac{ drf }{ drb * (drb + drf) } \\\\[10pt]
    \gamma_4 &= \frac{ dzd } {hu * (dzu + dzd) } \\\\[10pt]
  \end{split}
\quad\quad
  \begin{split}
    \beta_2 &= - \frac{ 2 }{ drb * drf } \\\\[10pt]
    \beta_5 &= -\frac{ 2 }{ dzd * dzu } \\\\[10pt]
    \gamma_2 &= - \frac{ drb - drf }{ drb * drf } \\\\[10pt]
    \gamma_5 &= \frac{ dzu - dzd } { hd * dzu } \\\\[10pt]
  \end{split}
\quad\quad
\begin{split}
    \beta_3 &= \frac{ 2 }{ drf * (drb + drf) } \\\\[10pt]
    \beta_6 &= \frac{ 2 }{ dzd * (dzu + dzd) } \\\\[10pt]
    \gamma_3 &= \frac{ drb }{ drf * (drb + drf) } \\\\[10pt]
    \gamma_6 &= \frac{ dzu } {hd * (dzu + dzd) } \\\\[10pt]
\end{split}
\end{equation}
$$

## One-Sided First-Order-Differences, First and Second Derivatives:

$$
\begin{align}
&\frac{\partial P}{\partial z}  =  \omega_1 * P(r, z + h_1 + h_2) +  \omega_2 * P(r, z + h_1) +  \omega_3 * P(r, z) \\\\[10pt]  
&\frac{\partial P}{\partial z}  =  \omega_4 * P(r, z - h_1 - h_2) +  \omega_5 * P(r, z - h_1) +  \omega_6 * P(r, z) \\\\[10pt]  
\end{align} 
$$

Above, two forms are needed because we use each on both sides of a boundary. 

$$
\begin{equation}
  \begin{split}
    &\omega_1 = \frac{-h_1}{h_2 ( h_1 + h_2 ) } \\\\[10pt]  
    &\omega_4 = \frac{h_1}{h_2 ( h_1 + h_2 ) } \\\\[10pt]  
  \end{split}
\quad\quad
  \begin{split}
    &\omega_2 = \frac{h_1 + h_2}{h_1 h_2 } \\\\[10pt]  
    &\omega_5 = -\frac{h_1 + h_2}{h_1 h_2  } \\\\[10pt]  
  \end{split}
\quad\quad
\begin{split}
    &\omega_3 = -\frac{2h_1 + h_2}{h_2 ( h_1 + h_2 ) } \\\\[10pt]  
    &\omega_6 = \frac{2h_1 + h_2}{h_2 ( h_1 + h_2 ) } \\\\[10pt]  
\end{split}
\end{equation}
$$
