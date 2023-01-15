$$
\begin{align}
f^{\prime\prime} \approx D^2 f(x) = & A f(x + h_+) + B f(x) + C f(x - h_-) \label{eq1}\tag{1} \\\\[10pt]  
\end{align} 
$$

Above, assume $h_+ \neq h_-$.  

Expand $f(x + h_+)$ and $f(x - h_-)$ in a taylor series with remainder about x to get:  

$$
\begin{align}
f(x \pm h) = f(x) \pm h_\pm f^\prime (x) + \frac{h^2_\pm}{2} f^{\prime\prime}(x) \pm \frac{h^3_\pm}{6} f^{(3)}(x) \pm \frac{h^4_\pm}{24} f^{(4)}(x)  \label{eq2}\tag{2} \\\\[10pt]  
\end{align} 
$$
  
Where $x-h_- \leq \xi_- \leq x \leq \xi_+ \leq x + h_+$
  
Plugging (2) into (1) gives

$$
\begin{align}
f^{\prime\prime} & \approx A f(x + h_+) + B f(x) + C f(x - h_-) \\\\[10pt]
& = (A + B + C) f(x) + (A-h_+ - Ch_-) f^\prime(x) + \frac{1}{2}(A h_+^2 + C h_-^2) f^{\prime\prime}(x)
+ \frac{1}{6} (A h_+^3 - C h_-^3)f^{\prime\prime\prime}(x) + 
+ \frac{1}{24} (A h_+^4 f(\xi_+) + C h_-^4 f(\xi_-)
\end{align} 
$$
