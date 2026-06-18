# OPTIONS USING TOML

The constant parameters and options are provided by the `.toml` file.

It is reminded that
$1 W = 1 J s^{-1}$

## Path: [path]

As provided in the example
--------------------------

| Param                       | Example                       | Description                                 |
| :-------------------------- | :---------------------------- | :------------------------------------------ |
| StationName                 | Timoleague                    | -                                           |
| Path_Input                  | DATA\\INPUT                   | -                                           |
| Path_Output                 | DATA\\OUTPUT                  | -                                           |
| Filename_Input_ClimateCsv   | Timoleague_Climate_Minute.csv | -                                           |
| Filename_Output_Plot        | Timoleague_Pet_10minutes.svg  | -                                           |
| Filename_Output_TableCsv    | Timoleague_Pet_10minutes.csv  | Time step as provided by input file         |
| Filename_Output_TableΔTCsv | Timoleague_Pet_ΔToutput.csv  | Time step as provided in [output]ΔT_Output |

## Date [date]

The start and end date of simulation which can be different than the one provided in the input file
---------------------------------------------------------------------------------------------------

| Param      | Example              | Description                                                  |
| :--------- | :------------------- | :----------------------------------------------------------- |
| Date_Start | [2023, 1, 1, 0, 0]   | Starting date of simulation [Year, Month, Day, Hour, Minute] |
| Date_Start | [2023, 12, 31, 0, 0] | Ending date of simulation [Year, Month, Day, Hour, Minute]   |

## Fags [flag]

---

| Param      | Example | Description                                                                         |
| :--------- | :------ | :---------------------------------------------------------------------------------- |
| 🎏_PetObs  | true    | If true then observed PET is provided in the input file                             |
| 🎏_RaParam | true    | if false then computed with petFunc.aerodynamic.Rₐ_INV_AERODYNAMIC_RESISTANCE(...) |
| 🎏_RsParam | false   | if false then computed with petFunc.aerodynamic.Rₛ_SURFACE_RESISTANCE(...)         |
| 🎏_Plot    | true    | if true then plotting output                                                        |
| 🎏_Table   | true    | if true tables saved as .csv                                                        |

## Outputs [output]

---

| Param      | Example | Description                                                                              |
| ---------- | ------- | ---------------------------------------------------------------------------------------- |
| ΔT_Output | 86400   | [seconds] time step of output starting at Date_Start for `Filename_Output_TableΔTCsv` |

## Missing [missings]

---

| Param          | Example | Description                                                                                                          |
| -------------- | ------- | -------------------------------------------------------------------------------------------------------------------- |
| ΔTmax_Missing | 14400   | [second] maximum time were there is consecutative data missing before flagged as missing in Filename_Output_TableCsv |
| MissingValue   | -9999   | Value of missing data in the input file Filename_Input_ClimateCsv                                                    |

## Physical constants: [cst]

---

| Param    |       Units       | Value         | Description                                    |
| :------- | :----------------: | :------------ | :--------------------------------------------- |
| Cₚ      |   [J kg-1 °C-1]   | 1013.0        | Cp                                             |
| Gsc      | [J m-2 second⁻¹] | 82000         | Solar constant                                 |
| Karmen   |        [-]        | 0.41          | Karmen                                         |
| T_Kelvin |      [Kelvin]      | 273.15        | Conversion from C to Kelvin                    |
| σ       |   [W m−2 K−4]   | 0.00000005674 | Stefan-Boltzmann constant                      |
| ϵ       |        [-]        | 0.622         | ratio molecular weight of water vapour/dry air |
| ℜ       |    [J kg-1 K-1]    | 287           | specific gas constant                          |
| ρwater  |      [kg m-3]      | 1000          | density of water                               |

## Parameters [param]

The parameters can be varied
----------------------------

| Param                 |  Units    |  Value    |  Description                                                  |
| --------------------- | --------- | --------- | ------------------------------------------------------------- |
| Latitude              |  [degree] |  52.61582 |Latitude                                                     |
| Longitude             | [degree]  | -6.31438  |Longitude                                                    |
| Longitude_LocalTime   |  [-]      |  0.0      |Longitude of center of time zone East to west e.g. greenwich |
| Zaltitude             |  [m]      |  26.0     |Altitude                                                   |
| α                    |  [-]      |  0.25     | Albedo or canopy reflection coefficient                      |
| SoilHeatFlux_Sunlight |  [-]      |  0.2      |Adjustment of soil heat flux parameters                      |
| SoilHeatFlux_Night    |  [-]      |  0.5      | Adjustment of soil heat flux parameters                      |

*** IF <🎏_Ra_Param> = true


  RaParam              = 300.0 # 208.0  aerodynamic resistance to turbulent


ELSE


  Hcrop               = 0.1 # [m] height of the crop
  Z_Humidity          = 2.0 # [m] height from ground of measuring humidity;
  Z_Wind              = 2.0 # [m] height from ground of measuring wind;


 *** IF <🎏_RS_Param> = true



"Rₛ"  = 90.0 # [s m-1] 40 - 70.0



ELSE



R_Stomatal          = 140.0 # <70-90> stomatal resistance of the well-illuminated leaf [s m⁻¹]
