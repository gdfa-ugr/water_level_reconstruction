
# Future water level reconstrucion 

This code applies the methodology developed in (https://doi.org/10.1016/j.coastaleng.2019.103512) and (https://doi.org/10.1016/j.coastaleng.2021.103872) for the reconstruction of historical and future continuous time series of total water levels along a transitional coastal system using the hybrid downscaling technique. As an example, this code is applied at the Guadalete estuary (South West, Spain). 

The main block of this code are:

- Selection of the representative cases throught the Maximum Dissimilarity Algorithm (MDA)
- Read of water levels from Delft3D simulations
- Reconstruction of continuous total water level series through Radial Basis Functions (RBF) including the calculation of the shape form.
## Authors

This code has been developed within the Environmental Fluid Dynamics Group (University of Granada) by the following authors:

- Juan Del-Rosal-Salido
- Pedro Folgueras
- Miguel Ortega-Sánchez
- Sebastian Solari
- Miguel Á. Losada

## License

This package is free to use under the MIT License. If you use it in your research, please cite our publications.

## How to cite

* J. Del-Rosal-Salido, P. Folgueras, M. Ortega-Sánchez, and M. A. Losada (2019).
  “Beyond flood probability assessment: An integrated approach for characterizing extreme
  water levels along transitional environments”. In: Coastal Engineering 152,
  p. 103512. ISSN: 0378-3839. URL: https://doi.org/10.1016/j.coastaleng.
  2019.103512

* J. Del-Rosal-Salido, P. Folgueras, M. Ortega-Sánchez, and M. A. Losada (2021).
  “Flood management challenges in transitional environments: assessing the effects
  of sea-level rise on compound flooding in the 21st century”. In: Coastal Engineering, 
  p. 103872. ISSN 0378-3839. URL: https://doi.org/10.1016/j.coastaleng.2021.103872