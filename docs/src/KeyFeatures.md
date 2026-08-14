# INTRODUCTION

## Key features

The ***Penman-Monteith TimeStep.jl*** software computes Potential Evapotranspiration by using the algorithm of Penman-Monteith FAO 56 (Allen et al., 1998) [FAO56](https://www.fao.org/4/x0490e/x0490e00.htm)

The Penman-Monteith TimeStep.jl software has the following features of interest:

- **Options** for each simulation are recorded in the input TOML file;
- **Parameters** can be modified in the TOML file;
- **Time step of input** less than a day, (e.g.  hourly or smaller);
- **Time step of output** computes potential evapotranspiration either at the time step of the input file or at a time step greater than the input file, (e.g. daily);
- **Missing** input data is populated by performing linear interpolation.

## Reference
Allen, R. G., L. S. Pereira, D. Raes, and M. Smith (1998), Crop evapotranspiration, Guidelines for computing crop water requirements., FAO, Rome, Italy.