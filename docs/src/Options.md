# OPTIONS USING TOML

The constant parameters and options are provided by the `.toml` file.

It is reminded that
$1 W = 1 J s^{-1}$

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

## Path: [path]

As provided in the example:

| Param                       |  Example                       |  Description                                 |
| --------------------------- | ------------------------------ | -------------------------------------------- |
| StationName                 |  Timoleague                    |  -                                           |
| Path_Input                  |  DATA\\INPUT                   |  -                                           |
| Path_Output                 |  DATA\\OUTPUT                  |  -                                           |
| Filename_Input_ClimateCsv   |  Timoleague_Climate_Minute.csv |  -                                           |
| Filename_Output_Plot        | Timoleague_Pet_10minutes.svg   |  -                                           |
| Filename_Output_TableCsv    |  Timoleague_Pet_10minutes.csv  |  Time step as provided by input file         |
| Filename_Output_TableΔTCsv |  Timoleague_Pet_ΔToutput.csv  |  Time step as provided in [output]ΔT_Output |


---

## Date [date]

```
Date_Start = [2023,1,1,0,0] # Starting date of simulation [Year, Month, Day, Hour, Minute]
Date_End = [2023,12,31,0,0]   # Ending date of simulation [Year, Month, Day, Hour, Minute]
```

## Flags [flag]

"🎏_PetObs"   = true # <true> or <false> if having observed PET
"🎏_RaParam" = true # <true> or <false> if <false> then computed with petFunc.aerodynamic.Rₐ_INV_AERODYNAMIC_RESISTANCE(...)
"🎏_RsParam" = false # <true> or <false> if <false> then computed with petFunc.aerodynamic.Rₛ_SURFACE_RESISTANCE(...)

```
# Outputs
	"🎏_Plot"     = true # <true> or <false> if plotting
	"🎏_Table"    = true # <true> or <false> if tables in csv
```

[output]
"ΔT_Output" = 86400 # 86400 [mm] time step of output starting at Date_Start

[missings]
"ΔTmax_Missing" = 14400 # [second] maximum time were there is consecutative data missing before flagged as missing
MissingValue = -9999 # Value of missing data in the input

[param]
Latitude              = 52.61582 # [degree]
Longitude             = -6.31438 # [degree]
Longitude_LocalTime   = 0.0 # Longitude of center of time zone East to west e.g. greenwich
Zaltitude             = 26.0 # [m] altitude;
"α"                   = 0.25 # 0.23 [-] albedo or canopy reflection coefficient
SoilHeatFlux_Sunlight = 0.2 # 0.1 [-] Adjustment of soil heat flux parameters
SoilHeatFlux_Night    = 0.5  # 0.6[-] Adjustment of soil heat flux parameters

*** IF <🎏_Ra_Param> = true

```
  RaParam              = 300.0 # 208.0  aerodynamic resistance to turbulent
```

ELSE

```
  Hcrop               = 0.1 # [m] height of the crop
  Z_Humidity          = 2.0 # [m] height from ground of measuring humidity;
  Z_Wind              = 2.0 # [m] height from ground of measuring wind;


 *** IF <🎏_RS_Param> = true

```

"Rₛ"  = 90.0 # [s m-1] 40 - 70.0

```

ELSE

```

R_Stomatal          = 140.0 # <70-90> stomatal resistance of the well-illuminated leaf [s m⁻¹]

```

# --------------------------------------------

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


```
