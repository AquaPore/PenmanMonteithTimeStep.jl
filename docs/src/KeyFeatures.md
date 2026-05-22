# Introducing features for PenmanMonteithTimeStep.jl software

## Key features

The ***Penman-Monteith TimeStep.jl*** software computes Potential Evapotranspiration by using the algorithm of Penman-Monteith FAO 56 [FAO56](https://www.fao.org/4/x0490e/x0490e00.htm)

"The so-called reference crop evapotranspiration or reference evapotranspiration, denoted as potential evapotranspiration ETp. The reference surface is a hypothetical grass reference crop with an assumed a fixed crop height, a fixed surface resistance and a fixed albedo. The reference surface closely resembles an extensive surface of green, well-watered grass of uniform height, actively growing and completely shading the ground. The fixed surface resistance implies a moderately dry soil surface resulting from about a weekly irrigation frequency"

The Penman-Monteith TimeStep.jl software has the following features:

- **Options** for each simulation are recorded in the input TOML file;
- **Parameters** can be modified in the TOML file;
- **Time step**  of the input file less than a day, (e.g.  hourly or smaller);
- **The time step** of the output computed potential evapotranspiration can be greater than the time step of the input file, (e.g. daily);
- **Missing** input data is populated by performing linear interpolation.
