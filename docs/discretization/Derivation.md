# Page One

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
f^{\prime\prime} & \approx A f(x + h_+) + B f(x) + C f(x - h_-) = \\\\[10pt]
& (A + B + C) f(x) + (A-h_+ - Ch_-) f^\prime(x) + \frac{1}{2}(A h_+^2 + C h_-^2) f^{\prime\prime}(x) + \label{eq3}\tag{3} \\\\[10pt]
& \frac{1}{6} (A h_+^3 - C h_-^3) f^{\prime\prime\prime}(x) + \frac{1}{24} (A h_+^4 f(\xi_+) + C h_-^4 f(\xi_-)
\end{align} 
$$
  
To get an expression for the second derivatives, we must set:

$$
\begin{align}
& A + B + C = 0 \\\\[10pt] 
& Ah_+ - Ch_-=0 \label{eq4}\tag{4} \\\\[10pt] 
& \frac{1}{2}(Ah_+^2 + ch_-^2)=1 \\\\[10pt] 
\end{align} 
$$


Solving (4) gives 
$A = \frac{2}{h_+(h_+ + h_-)}$, 
$B = \frac{-2}{h_+ + h_-}$, 
$C = \frac{2}{h_-(h_+ + h_-)}$

So $f^{\prime\prime}(x) \approx \frac{2}{h_+(h_+ + h_-)} f(x + h_+) \frac{-2}{h_+ + h_-} f(x) + \frac{2}{h_-(h_+ + h_-)} f(x-h_-)$

illegible (two lines about error)

Should the error be too large we correct to a higher accuracy approximation by 
$f^{\prime\prime} \approx A f(x + h_{++}) + B f(x + h_+) + C f(x) + D f(x - h_-) + E f(x - h_{--})  $

This becomes:  

$$
\begin{align}
f^{\prime\prime} & \approx (A + B + C + D + E) f(x) \\\\[10pt] 
& + (Ah_{++} + Bh_+ - Dh_- - Eh_{--}) f^\prime(x) \\\\[10pt]
& + \frac{1}{2}( A h_{++}^2 + B h_+^2 + D h_-^2 + E h_{--}^2) f^{\prime\prime} \\\\[10pt]
& + \frac{1}{6}( A h_{++}^3 + B h_+^3 - D h_-^3 - E h_{--}^3) f^{\prime\prime\prime} \\\\[10pt]
& + \frac{1}{24}( A h_{++}^4 + B h_+^4 - D h_-^4 - E h_{--}^4) f^{(4)} + \text{error term} \\\\[10pt]
\end{align}
$$

illegible

We must then solve the following: 

$$
\begin{align}
A + B + C + D + E = 0 \\\\[10pt]
A h_{++} + B h_+ - D h_- - E h_{--} = 0 \\\\[10pt]
A h_{++}^2 + B h_+^2 + D h_-^2 + E h_{--}^2 = 1 \\\\[10pt]
A h_{++}^3 + B h_+^3 - D h_-^3 - E h_{--}^3 = 0 \\\\[10pt]
A h_{++}^4 + B h_+^4 - D h_-^4 - E h_{--}^4 = 0 \\\\[10pt]
\end{align}
$$


# Page Two

(Special case) Also, if $h_+ = h_-$, we have the following second derivative: 

$f^{\prime\prime} \approx \frac{f(x + h) - 2 h f(x) + f(x-h)}{h^2} + O(h^4)$

For a first derivative, take

$$
\begin{align}
f^\prime (x) & \approx A f(x + h) + B f(x) \\\\[10pt]
& = A ( f(x) + f^\prime (x) h + f^ {\prime\prime} (\xi) \frac{h^2}{2} ) + B f(x)
\end{align}
$$

Substitute $A + B + C = 0$, $Ah = 1$  

Then $B = -A = \frac{-1}{h}$ and $f^\prime (x) \approx \frac{f(x + h) - f(x)}{h} + f^{\prime\prime}(\xi) \frac{h}{2}$ illegible

A better approx is  

$$
\begin{align}
f^\prime (x) & \approx A f(x + h_+) + B f(x) + C f(x-h_-) \\\\[10pt]
& = (A + B + C) f(x) + (A h_+ - C h_-) f^\prime (x) \\\\[10pt]
& + \frac{1}{2} (A h_+^2 + C h_- ^2) f^ {\prime\prime} (x) + \frac{1}{6} (A h_+^3 f^{\prime\prime\prime} (\xi_+) - C h_-^3 f^{\prime\prime\prime} (\xi_-)
\end{align}
$$

Set $A + B + C = 0$, $A h_+ - C h_- = 1$, $A h_+^2 + C h_-^2 = 0$ to get:  

$$
\begin{align}
A = \frac{h_- / h_+}{h_+ + h_-} \\\\[10pt]
B = \frac{h_+ - h_-}{h_+ h_-} \\\\[10pt]
C = \frac{-h_+/ h_-}{h_+ + h_-}
\end{align}
$$

or  

$$
\begin{align}
f^{\prime\prime} \approx \frac{h_- / h_+}{h_+ + h_-} f(x + h_+) + \frac{h_+ - h_-}{h_+ h_-} f(x) + \frac{-h_+/ h_-}{h_+ + h_-} f(x - h_-) + 
O(\text{larger of } \frac{h_+^2 h_-}{h_+ + h_-}, \frac{h_-^2 h_+}{h_+ + h_-})
\end{align}
$$

(Special case) note, for $h_+ = h_-$, $f^\prime (x) = \frac{1}{2h} ( f(x + h) - f(x - h) ) + O(\frac{h^2}{2})$
