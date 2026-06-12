# PenmanMonteithTimeStep

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://AquaPore.github.io/PenmanMonteithTimeStep.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://AquaPore.github.io/PenmanMonteithTimeStep.jl/dev/)
[![Build Status](https://github.com/AquaPore/PenmanMonteithTimeStep.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/AquaPore/PenmanMonteithTimeStep.jl/actions/workflows/CI.yml?query=branch%3Amaster)



## Key features

The ***Penman-Monteith TimeStep.jl*** software computes Potential Evapotranspiration by using the algorithm of Penman-Monteith FAO 56 [FAO56](https://www.fao.org/4/x0490e/x0490e00.htm)

The Penman-Monteith TimeStep.jl software has the following features of interest:

- **Options** for each simulation are recorded in the input TOML file;
- **Parameters** can be modified in the TOML file;
- **Time step of input** less than a day, (e.g.  hourly or smaller);
- **Time step of output** computes potential evapotranspiration either at the time step of the input file or at a time step greater than the input file, (e.g. daily);
- **Missing** input data is populated by performing linear interpolation.

The documentation is found in [Documnentaion](https://aquapore.github.io/PenmanMonteithTimeStep.jl/dev/)