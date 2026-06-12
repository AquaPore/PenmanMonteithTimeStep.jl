# Home

The following is the documentation for the PenmanMonteithTimeStep.jl software written in the [Julia Programming Language .](https://julialang.org/])

## Key features

The ***Penman-Monteith TimeStep.jl*** software computes Potential Evapotranspiration by using the algorithm of Penman-Monteith FAO 56 [FAO56](https://www.fao.org/4/x0490e/x0490e00.htm)

The Penman-Monteith TimeStep.jl software has the following features of interest:

- **Options** for each simulation are recorded in the input TOML file;
- **Parameters** can be modified in the TOML file;
- **Time step of input** less than a day, (e.g.  hourly or smaller);
- **Time step of output** computes potential evapotranspiration **(a)** at the time step of the input file, **(b)** at a time step of choice greater than the input file, (e.g. daily);
- **Missing data** is automatically populated by performing linear interpolation.
