# About
R PDE Solver - Pre-atherosclerotic ﬂow and oncotically active solute transport across the arterial endothelium


# Table of contents
1. [Introduction](#introduction)
2. [The Domain](#domainOutline)
3. [Building the Pressure Matrix](#buildingPressureMatrix)
  1. [Interior Grid-Points](./docs/Interior%20Grid%20Points.md)  
    i. [Left and Right Boundary](./docs/Left%20%26%20Right%20Boundaries.md)  
    ii. [Top and Bottom Boundary](./docs/Top%20%26%20Bottom%20Boundaries.md)  
  2. [GX-Intima Boundary: Endothelial Cell](./docs/Endothelial%20Cell.md)
  3. [GX-Intima Boundary: Normal Junction](./docs/Endothelial%20Cell%20Normal%20Junction.md)  
  4. [Intima-Media Boundary: Finestra](./docs/Intima-Media%20Finestra.md)  
  5. [Intima-Media Boundary: Non-Finestra](./docs/Intima-Media%20Non-Finestra.md)  
4. [Building the Concentration Matrix](#buildingConcentrationMatrix)
5. [Solution Scheme](./docs/Solving%20Matrix%20Equations.md)




## This is the introduction <a name="introduction"></a>
Some introduction text, formatted in heading 2 style


## Domain <a name="domainOutline"></a>
The grid is broken into several sections. 
In the Z-direction: Glycocalx -> Intima -> Media  
On the Glycocalx-Intima boundary we have two sections: the Endothelial cell and the Normal Junction.
On the Intima-Media boundary we also have two sections: The Finestra and non-finestra. 

## Building the Pressure Matrix <a name="buildingPressureMatrix"></a>
The pressure matrix is made of an equation on all interior grid points. Furthermore, each boundary has it's own set of equations and conditions. 

1. [Interior Grid-Points](./docs/Interior%20Grid%20Points.md)  
  i. [Left and Right Boundary](./docs/Left%20%26%20Right%20Boundaries.md)  
  ii. [Top and Bottom Boundary](./docs/Top%20%26%20Bottom%20Boundaries.md)  
2. [GX-Intima Boundary: Endothelial Cell](./docs/Endothelial%20Cell.md)
3. [GX-Intima Boundary: Normal Junction](./docs/Endothelial%20Cell%20Normal%20Junction.md)  
4. [Intima-Media Boundary: Finestra](./docs/Intima-Media%20Finestra.md)  
5. [Intima-Media Boundary: Non-Finestra](./docs/Intima-Media%20Non-Finestra.md)  
