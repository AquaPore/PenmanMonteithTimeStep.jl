## Input data

As provided as an example in the input csv file. The time steps does not have to be constant but msut be less than a day

* Year
* Month
* Day
* Hour
* Minute
* Humidity[%]
* SolarRadiation[W/m²]
* AirTemperature[°C]
* WindSpeed[m/s]

# MODEL

The Penman-Monteith model is written as follow:

```math
\varDelta E_{tp}=\frac{\varDelta (\varDelta R_{\mathrm{adₙ}}-G)+\rho _{\mathrm{ₐᵢᵣ}}C_{\mathrm{ₚ}}\frac{\left[ E_{\mathrm{ₛ}}-E_{\mathrm{ₐ}} \right]}{R\mathrm{ₐ}}}{\lambda .\rho _{\mathrm{water}}\left[ \varDelta +\gamma \left( 1+\frac{R\mathrm{ₛ}}{R\mathrm{ₐ}} \right) \right]}
```

Where

* **Cp**     : [J kg⁻¹ °C⁻¹] specific heat at constant pressure.
* **Eₐ**     : [kPa] actual vapour pressure computed by Eₐ_ACTUAL_VAPOUR_PRESSURE_RH(; RelativeHumidity, Eₛ)
* **Eₛ**     : [kPa] saturation vapour pressure computed by Eₛ_SATURATION_VAPOUR_PRESSURE(; Temp)
* **G()**    : [MJ m⁻² hour⁻¹] is the soil heat flux density function computed by G_SOIL_HEAT_FLUX_HOURLY(; DateTimeMinute, Latitude, Longitude, ΔRadₙ, Zaltitude, SoilHeatFlux_Sunlight, SoilHeatFlux_Night)
* **Rₐ_Inv :** [m s⁻¹] inverse of the aerodynamic resistancecomputed by Rₐ_INV_AERODYNAMIC_RESISTANCE(; Hcrop, Karmen, Wind, Z_Humidity, Z_Wind)
* **Rₛ     :** [s m⁻¹] surface resistance computed by Rₛ_SURFACE_RESISTANCE(; R_Stomatal, Hcrop)
* **Δ()    :** [kPa°C⁻¹] slope of the relationship between saturation vapour pressure and temperature computed by Δ_SATURATION_VAPOUR_P_CURVE(; Temp)
* **ΔRadₙ  :** [MJ m⁻² hour⁻¹] net radiation at the crop surface computed by ΔRadₙ_NET_RADIATION(; Radₙₗ, Radₙₛ)
* **γ      :** [kPa°C⁻¹] psychrometric constant computed by γ_PSYCHROMETRIC_CONSTANT(; Pressure)
* **λᵥ     :** latent heat of vaporization which is the energy required to evaporize 1mm of water computed by λ_LATENT_HEAT_VAPORIZATION(; Temp)
  * ρwater = 1000 kg m⁻³ density of water
* **ρₐᵢᵣ() :** atmospheric density at constant pressure function computed by ρₐᵢᵣ_AIR_DENSITY(; Eₐ, Pressure, ℜ, T_Kelvin, Temp)