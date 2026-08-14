---
# Input & output
---

## Input data

As provided in the example in the input .csv file `Timoleague_Cilmate_Minute.csv`. The time step does not have to be constant. The software is designed to acurately provide results for time step less than a day.

The Table below shows the input data:

---

| INPUT                       | UNIT   | REMARKS                                                                            |
| :-------------------------- | :----- | :--------------------------------------------------------------------------------- |
| Year                        | -      | -                                                                                  |
| Month                       | -      | -                                                                                  |
| Day                         | -      | -                                                                                  |
| Hour                        | -      | -                                                                                  |
| Minute                      | -      | -                                                                                  |
| Humidity                    | [0-1]    | -                                                                                  |
| SolarRadiation              | [W/m²] | -                                                                                  |
| AirTemperature              | [°C]-  | -                                                                                  |
| WindSpeed                   | [m/s]  | -                                                                                  |
| PotentialEvapotranspiration | [mm]   | Observed data. If you do not have observed data keep it blank, but keep the header |

### Interpolation of missing data

The software enables to perform linear interpolation of missing data of the variables. The value of the missing value is `[toml][missings][MissingValue]`

## Output

In the folder 'Data/OUTPUT/'.  There are two outputs files:

---

| FILENAME                                                | REMARKS                                                                   |
| :------------------------------------------------------ | :------------------------------------------------------------------------ |
| Filename_Output_TableCsv=Timoleague_Pet_10minutes.csv   | Same time step as input                                                   |
| Filename_Output_TableΔTCsv= Timoleague_Pet_ΔToutput.csv | Time step of the second output `[toml][output][ΔT_Output]` in `[seconds]` |

### Output file description

---

| OUTPUT                       | UNIT           | REMARKS                                                                                                                                                                         |
| :--------------------------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Date                         | [Julia format] | -                                                                                                                                                                               |
| Pet_Obs                      | [mm/ TimeStep] | If provided or else outputs is blanks.                                                                                                                                          |
| Pet_Sim                      | [mm/ TimeStep] | -                                                                                                                                                                               |
| Potential evapotranspiration | [mm]           | -                                                                                                                                                                               |
| 🎏_DataMissing              | [Bool]         | `Flag` that the output has heigh uncertainty due to interpolated of missing data. `🎏_DataMissing=true` when the missing data is greater than `[toml][missing][ΔTmax_Missing]` |

