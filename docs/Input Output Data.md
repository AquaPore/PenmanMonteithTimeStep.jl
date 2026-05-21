# Input output data

## Input data

As provided as an example in the input csv file. The time steps does not have to be constant but must be less than a day

* Year
* Month
* Day
* Hour
* Minute
* Humidity [%]
* SolarRadiation[W/m²]
* AirTemperature [°C]
* WindSpeed [m/s]

## Output from the PenmanMonteithTimeStep software

Outputs in *.csv* for non iterpolated (same time step) and interpolated output with can be given different time step than as in the inputfile. The PET output is always positive.

* Dates
* Potential evapotranspiration [mm]
* 🎏_DataMissing