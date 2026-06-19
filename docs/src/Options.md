# OPTIONS USING TOML

The constant parameters and options are provided by the `.toml` file.

It is reminded that
$1 W = 1 J s^{-1}$

## [path] - Path:

As provided in the example:

---

| Param                      | Example                       | Description                                |
| -------------------------- | ----------------------------- | ------------------------------------------ |
| StationName                | Timoleague                    | -                                          |
| Path_Input                 | DATAINPUT                     | -                                          |
| Path_Output                | DATAOUTPUT                    | -                                          |
| Filename_Input_ClimateCsv  | Timoleague_Climate_Minute.csv | -                                          |
| Filename_Output_Plot       | Timoleague_Pet_10minutes.svg  | -                                          |
| Filename_Output_TableCsv   | Timoleague_Pet_10minutes.csv  | Time step as provided by the input file        |
| Filename_Output_TableΔTCsv | Timoleague_Pet_ΔToutput.csv   | Time step as provided in `[output]ΔT_Output` |

## [date] - Date

The *start* and *end* date of simulation can be differ than provided by the input file

---

| Param      | Example              | Description                                                    |
| ---------- | -------------------- | -------------------------------------------------------------- |
| Date_Start | [2023, 1, 1, 0, 0]   | Starting date of simulation `[Year, Month, Day, Hour, Minute]` |
| Date_Start | [2023, 12, 31, 0, 0] | Ending date of simulation `[Year, Month, Day, Hour, Minute]`   |

## [output] - Outputs

For the output file `Filename_Output_TableΔTCsv`

---

| Param     | Example | Unite     | Description                                  |
| --------- | ------- | --------- | -------------------------------------------- |
| ΔT_Output | 86400   | [seconds] | time step of output starting at `Date_Start` |

## [missings] - Missing

For the input file `Filename_Output_TableCsv`

---

| Param         | Example | Description                                                                              |
| ------------- | ------- | ---------------------------------------------------------------------------------------- |
| ΔTmax_Missing | 14400   | [second] maximum time were there is consecutative data missing before flagged as missing |
| MissingValue  | -9999   | Value of missing data                                                                    |

## [flag] - Flags

---

| Param      | Example | Description                                                                                     |
| ---------- | ------- | ----------------------------------------------------------------------------------------------- |
| 🎏_PetObs  | true    | If*true* then observed PET is provided in the input file                                        |
| 🎏_RaParam | true    | if*false* then `RaParam` is computed with `petFunc.aerodynamic.Rₐ_INV_AERODYNAMIC_RESISTANCE()` |
| 🎏_RsParam | false   | if*false* then `RsParam` is computed with `petFunc.aerodynamic.Rₛ_SURFACE_RESISTANCE()`         |
| 🎏_Plot    | true    | if*true* then plotting output                                                                   |
| 🎏_Table   | true    | if*true* tables saved as .csv                                                                   |

## [param] - Parameters

Could be modified

| Param                 | Units    | Value    | Description                                                  |
| --------------------- | -------- | -------- | ------------------------------------------------------------ |
| Latitude              | [degree] | 52.61582 | Latitude                                                     |
| Longitude             | [degree] | -6.31438 | Longitude                                                    |
| Longitude_LocalTime   | [-]      | 0.0      | Longitude of center of time zone East to west e.g. greenwich |
| Zaltitude             | [m]      | 26.0     | Altitude                                                     |
| α                     | [-]      | 0.25     | Albedo or canopy reflection coefficient                      |
| SoilHeatFlux_Sunlight | [-]      | 0.2      | Adjustment of soil heat flux parameters                      |
| SoilHeatFlux_Night    | [-]      | 0.5      | Adjustment of soil heat flux parameters                      |

### Depending on`🎏_Ra_Param`

#### ***IF `🎏_Ra_Param = true`***

---

| Param   | Units | Value | Description                         |
| ------- | ----- | ----- | ----------------------------------- |
| Param   | Unit  | Value | Description                         |
| RaParam | []    | 300   | aerodynamic resistance to turbulent |

#### ***IF `🎏_Ra_Param = false`***

`RaParam` is computed from `petFunc.aerodynamic.Rₐ_INV_AERODYNAMIC_RESISTANCE()` which requires the following variables:

---

| Param      | Unit | Value | Description                               |
| ---------- | ---- | ----- | ----------------------------------------- |
| Hcrop      | [m]  | 0.1   | height of the crop                        |
| Z_Humidity | [m]  | 2.0   | height from ground of measuring humidity; |
| Z_Wind     | [m]  | 2.0   | height from ground of measuring wind      |

### Depending on `🎏_RS_Param`

#### ***IF `🎏_RS_Param = true`***

---

| Param | Unit    | Value | Description            |
| ----- | ------- | ----- | ---------------------- |
| Rₛ    | [s m⁻¹] | 90    | Aerodynamic resistance |

#### ***IF `🎏_RS_Param = false`***

Rₛ is computed from `petFunc.aerodynamic.Rₛ_SURFACE_RESISTANCE()` which requires the following variables:

---

| Param      | Unit    | Value | Description                                      |
| ---------- | ------- | ----- | ------------------------------------------------ |
| R_Stomatal | [s m⁻¹] | 140.0 | stomatal resistance of the well-illuminated leaf |

## [cst] - Physical constants:

Not recommended to modify.

---

| Param    | Units            | Value        | Description                                    |
| -------- | ---------------- | ------------ | ---------------------------------------------- |
| Cₚ       | [J kg⁻¹ °C⁻¹]    | 1013.0       | Cp                                             |
| Gsc      | [J m⁻2 second⁻¹] | 82000        | Solar constant                                 |
| Karmen   | [-]              | 0.41         | Karmen                                         |
| T_Kelvin | [-]              | 273.15       | Conversion from C to Kelvin                    |
| σ        | [W m−2 K−4]      | 0.0000000567 | Stefan-Boltzmann constant                      |
| ϵ        | [-]              | 0.622        | ratio molecular weight of water vapour/dry air |
| ℜ        | [J kg⁻¹ K⁻¹]     | 287.0        | specific gas constant                          |
| ρwater   | [kg m-3]         | 1000.0       | density of water                               |
