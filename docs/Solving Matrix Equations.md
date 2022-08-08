# Solution Scheme

## QR factorization 

As our matrices are very large, we use QR factorization to solve for pressure and concentration.  
QR factorization factors a matrix into an orthogonal component and an upper triangular component. Inverting the othogonal component is a simple transpose. 
This makes it easy to solve with back substitution, as shown below.

Q = orthogonal
R = upper triangular
Ax = B 
QRx = B
Rx = Q^T B
R is upper triangular -> solve with back substitution 

In R code:
```
A <- Matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3, ncol = 3)
B <- c(6, 7, 8)

print(A)
3 x 3 Matrix of class "dgeMatrix"
     [,1] [,2] [,3]
[1,]    1    4    7
[2,]    2    5    8
[3,]    3    6    9

qrd <- qr(A, LAPACK = TRUE)
x = qr.coef(qrd, B)

A %*% x

3 x 1 Matrix of class "dgeMatrix"
     [,1]
[1,]    6
[2,]    7
[3,]    8
```
