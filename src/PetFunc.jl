# =============================================================
#		module: petFunc
# =============================================================
module petFunc
# =============================================================
#		module: penmanmonteith
# =============================================================
module penmanmonteith

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#		FUNCTION : PENMAN_MONTEITH_HOURLY
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
	 PET_PENMAN_MONTEITH_HOURLY(; kwargs...) -> Return type

Description of the function

INPUT
   * Cp     : [J kg⁻¹ °C⁻¹] specific heat at constant pressure.
   * Eₐ     : [kPa] actual vapour pressure computed by Eₐ_ACTUAL_VAPOUR_PRESSURE_RH(; RelativeHumidity, Eₛ)
   * Eₛ     : [kPa] saturation vapour pressure computed by Eₛ_SATURATION_VAPOUR_PRESSURE(; Temp)
   * G()    : [MJ m⁻² hour⁻¹] is the soil heat flux density function computed by G_SOIL_HEAT_FLUX_HOURLY(; DateTimeMinute, Latitude, Longitude, ΔRadₙ, Zaltitude, SoilHeatFlux_Sunlight, SoilHeatFlux_Night)
   * Rₐ_Inv : [m s⁻¹] inverse of the aerodynamic resistancecomputed by Rₐ_INV_AERODYNAMIC_RESISTANCE(; Hcrop, Karmen, Wind, Z_Humidity, Z_Wind)
   * Rₛ     : [s m⁻¹] surface resistance computed by Rₛ_SURFACE_RESISTANCE(; R_Stomatal, Hcrop)
   * Δ()    : [kPa°C⁻¹] slope of the relationship between saturation vapour pressure and temperature computed by Δ_SATURATION_VAPOUR_P_CURVE(; Temp)
   * ΔRadₙ  : [MJ m⁻² hour⁻¹] net radiation at the crop surface computed by ΔRadₙ_NET_RADIATION(; Radₙₗ, Radₙₛ)
   * γ      : [kPa°C⁻¹] psychrometric constant computed by γ_PSYCHROMETRIC_CONSTANT(; Pressure)
   * λᵥ     : latent heat of vaporization which is the energy required to evaporize 1mm of water computed by λ_LATENT_HEAT_VAPORIZATION(; Temp)
	* ρwater = 1000 kg m⁻³ density of water
   * ρₐᵢᵣ() : atmospheric density at constant pressure function computed by ρₐᵢᵣ_AIR_DENSITY(; Eₐ, Pressure, ℜ, T_Kelvin, Temp)

OUTPUT
	* ETₒ: [mm J m⁻² ΔT⁻¹] is the reference evapotranspiration computed by the Penman-Monteith equation for hourly or shorter time steps.
"""
	function PET_PENMAN_MONTEITH_HOURLY(; Cₚ, Eₐ, Eₛ, G, Rₐ_Inv, ΔRadₙ, Rₛ, γ, Δ, λᵥ, ρₐᵢᵣ, ΔT₁, ρwater)

		ETₒ = (Δ * (ΔRadₙ - G) + ρₐᵢᵣ * Cₚ * max(Eₛ - Eₐ, 0.0) * Rₐ_Inv) / ((Δ + γ * (1.0 + Rₛ * Rₐ_Inv)) * λᵥ * ρwater)

		# convert from [m J m-2 second⁻¹] ➡ [mm J m-2 ΔT⁻¹]
		ETₒ = max(ETₒ, 0.0) * ΔT₁ * 1000.0
		return ETₒ
	end  # function: PENMAN_MONTEITH_HOURLY
# ------------------------------------------------------------------

end  # module: penmanmonteith
# ............................................................


# =============================================================
#		module: aerodynamic
# =============================================================
module aerodynamic

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#		FUNCTION :Rₐ_INV
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	rₐ: [s m⁻¹] AERODYNAMIC RESISTANCE,

	INPUT
		Z_Wind:  [m] height of wind measurements,
		Z_Humidity: [m]:  height of humidity measurements,
		wIND: [m s⁻¹] wind speed at height Z_Wind,
		Hcrop: [m] height of the crop

	PROCESSES
		Z_ZERO_PLANE() [m]zero plane displacement height ,
		Z_ROUGHNESS_MOMENTUM() [m] roughness length governing momentum transfer [m],
		Z_ROUGHNESS_TRANSFER() [m] roughness length governing transfer of heat and vapour [m],

	# CONSTANT
		k [m] von Karman's constant, 0.41 [-],
	"""
	function Rₐ_INV_AERODYNAMIC_RESISTANCE(; Hcrop, Karmen, Wind, Z_Humidity, Z_Wind)
		#------------------------------
		function Z_ZERO_PLANE(Hcrop)
			Z_0 = (2.0 / 3.0) * Hcrop
			return Z_0
		end
		#..............................

		#------------------------------
		function Z_ROUGHNESS_MOMENTUM(Hcrop)
			Z_RoughnessMomentum = 0.123 * Hcrop
			return Z_RoughnessMomentum
		end  # function: Z_ROUGHNESS_MOMENTUM
		#.....................................

		#------------------------------
		function Z_ROUGHNESS_TRANSFER(Z_RoughnessMomentum)
			Z_RoughnessTransfer = 0.1 * Z_RoughnessMomentum
			return Z_RoughnessTransfer
		end  # function: Z_ROUGHNESSMOMENTUM
		#........................................

		Z_0 = Z_ZERO_PLANE(Hcrop)
		Z_RoughnessMomentum = Z_ROUGHNESS_MOMENTUM(Hcrop)
		Z_RoughnessTransfer = Z_ROUGHNESS_TRANSFER(Z_RoughnessMomentum)


		P_Wind = ((log(max(Z_Wind - Z_0, 0.0) / Z_RoughnessMomentum)) * (log(max(Z_Humidity - Z_0, 0.0) / Z_RoughnessTransfer))) / Karmen^2

		Rₐ_Inv = Wind / P_Wind

		return Rₐ_Inv
	end  # function: Rₐ_INV_AERODYNAMIC_RESISTANCE
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION :  Rₛ_SURFACE_RESISTANCE
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Rₛ: [s m⁻¹] SURFACE RESISTANCE

	INPUT:
		* R_Stomatal: [s m⁻¹] bulk stomatal resistance of the well-illuminated leaf,
		* Hcrop: [m] height of the crop
	"""
	function Rₛ_SURFACE_RESISTANCE(; R_Stomatal, Hcrop)
		LAI = 24.0 * Hcrop
		LAIactive = LAI * 0.5
		# LAI = 3.0 # [3 - 4]
		LAIactive = LAI / (0.3 * LAI + 1.2)
		Rₛ = R_Stomatal / LAIactive
		return Rₛ
	end  # function: Rₛ_SURFACE_RESISTANCE
# ------------------------------------------------------------------

end  # module: aerodynamic
# ............................................................


# =============================================================
#		module: psychometric
# =============================================================
module physics
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#		FUNCTION : λ_LATENT_HEAT_VAPORIZATION
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	λᵥ [J kg-1] LATENT HEAT OF VAPORIZATION
	energy required to evaporize 1mm of water

	INPUT
		* Temp [ᵒC] air temperature
	"""
	function λ_LATENT_HEAT_VAPORIZATION(; Temp)
		λᵥ = (2503 - 2.39 * Temp) * 1.0E3
		return λᵥ
	end  # function: λ_LATENT_HEAT_VAPORIZATION
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : ATMOSPHERIC_PRESSURE
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	PRESSURE [kPa]

	INPUT
		* Temp [ᵒC] air temperature
		* Zaltitude;
	"""
	function ATMOSPHERIC_PRESSURE(; T_Kelvin, Temp, Zaltitude)
		Pressure = 101.3 * ((293.0 - 0.0065 * Zaltitude) / (T_Kelvin + Temp))^5.26
		return Pressure
	end  # function: ATMOSPHERIC_PRESSURE
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : γ_PSYCHROMETRIC
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	γ PSYCHROMETRIC CONSTANT [kPa °C-1],

	The specific heat at constant pressure is the amount of energy required to increase the temperature of a unit mass of air by one degree at constant pressure.

	INPUT:
		Pressure: [kPa] atmospheric pressure ,

	CONSTANTS:
		* λᵥ: [J kg-1], λ_LATENT_HEAT_VAPORIZATION(), latent heat of vaporization, "2.45" ,
		* Cp: [J kg-1 °C-1] specific heat at constant pressure, 1.013 10-3 ,
		* ε: ratio molecular weight of water vapour/dry air = 0.622.
	"""
	function γ_PSYCHROMETRIC(; Cₚ, Pressure, ϵ, λᵥ)
		γ = (Cₚ * Pressure) / (ϵ * λᵥ)
		return γ
	end  # function: γ_PSYCHROMETRIC
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : ρₐᵢᵣ_AIR_DENSITY
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	ρₐᵢᵣ MEAN AIR/ ATMOSPHERIC DENSITY AT CONSTANT PRESSURE [kg m ⁻³]

	INPUT:
		* Pressure: [kPa] Atmospheric pressure,
		* T_Kelvin: constant Conversion from C to Kelvin,
		* ℜ: [J kg-1 K-1] constants pecific gas constant

		PROCESSES
		# Tkv  [k] Virtual Temp
	"""
	function ρₐᵢᵣ_AIR_DENSITY(; Eₐ, Pressure, ℜ, T_Kelvin, Temp)
		Tkv = (T_Kelvin + Temp) / (1.0 - 0.378 * Eₐ / Pressure)
		ρₐᵢᵣ = 1000.0 * Pressure / (ℜ * Tkv)
		return ρₐᵢᵣ
	end  # function: ρₐᵢᵣ_AIR_DENSITY
# ------------------------------------------------------------------
end  # module: physics
# ............................................................


# =============================================================
#		module: humidity
# =============================================================
module humidity
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#		FUNCTION : Eᴼ_SATURATED_VAPOUR_PRESSURE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Eᴼ(Temp) [kPa]: SATURATION VAPOUR PRESSURE at the air temperature

		INPUT
		* Temp [ᴼc]
	"""
	function Eᴼ_SATURATION_VAPOUR_PRESSURE(; Temp)
		Eᴼ = 0.6108 * exp(17.27 * Temp / (Temp + 237.3))
		return Eᴼ
	end  # function: SATURATED_VAPOUR_PRESSURE
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Ea_ACTUAL_VAPOUR_PRESSURE_RH
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Eₐ [kPa] ACTUAL VAPOUR PRESSURE

	INPUT
	* RelativeHumidity: [0-1  degree of saturation of the air (eₐ) to the saturation (eₛ =eₒ(Temp)) vapour pressure at the same temperature (Temp):
	"""
	function Eₐ_ACTUAL_VAPOUR_PRESSURE_RH(; RelativeHumidity, Eₛ)
		@assert RelativeHumidity ≤ 1.0
		Eₐ = RelativeHumidity * Eₛ
		return Eₐ
	end  # function: Ea_ACTUAL_VAPOUR_PRESSURE_RH
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Δ_SATURATION_VAPOUR_P_CURVE
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Δ: [kPa°C-1] SLOPE OF SATURATION VAPOUR PRESSURE CURVE AT AIR TEMPERATURE Temp ,
	slope of the relationship between saturation vapour pressure and temperature

		INPUT
		* Temp [ᴼc]: air temperature
	"""
	function Δ_SATURATION_VAPOUR_P_CURVE(; Temp)
		# Δ = 4098.0 * 0.6108 * exp(17.27 * Temp / (Temp + 237.3)) / (Temp + 237.3) ^ 2.0

		Eₛ = humidity.Eᴼ_SATURATION_VAPOUR_PRESSURE(; Temp)

		Δ = 4098.0 * Eₛ / (Temp + 237.3)^2.0
		return Δ
	end  # function: Δ_SATURATION_VAPOUR_P_CURVE
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Ea_2_Tdew
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	""" not used """
	function Eₐ_2_Tdew(; Eₐ)
		P₁ = (1.0 / 17.27) * log(Eₐ / 0.6108)
		Tdew = 237.3 * P₁ / (1.0 - P₁)
		return Tdew
	end  # function: Ea_2_Tdew
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Ea_ACTUAL_VAPOUR_PRESSURE_RH
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"""
	 Eₐ_ACTUAL_VAPOUR_PRESSURE_Tdew(; kwargs...) -> Return type

Description of the function

# Keywords

- `Tdew`: Keyword description
"""
	function Eₐ_ACTUAL_VAPOUR_PRESSURE_Tdew(; Tdew)
		Eₐ = 0.6108 * exp((17.27 * Tdew) / (Tdew + 237.3))
		return Eₐ
	end  # function: Ea_ACTUAL_VAPOUR_PRESSURE_RH
# ------------------------------------------------------------------

end  # module: humidity
# ............................................................


# =============================================================
#		module: radiation
# =============================================================
module radiation
	using Dates, SolarPosition, Dates, TimeZones

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION :  ωₛ_SUNSET_HOUR_ANGLE
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
	 ωₛ_SUNSET_HOUR_ANGLE(; kwargs...) -> Return type

Description of the function

# Keywords

- `Latitude_Radian`: Keyword description
- `δ`: Keyword description
"""
	function ωₛ_SUNSET_HOUR_ANGLE(; Latitude_Radian, δ)
		ωₛᵤₙₛₑₜ = acos(-tan(Latitude_Radian) * tan(δ))
		return ωₛᵤₙₛₑₜ
	end # ωₛ_SUNSET_HOUR_ANGLE
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : SUNLIGHT_HOURS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
	 SUNLIGHT_HOURS(; kwargs...) -> Return type

Description of the function

# Keywords

- `DateTimeMinute`: Keyword description
- `Latitude`: Keyword description
- `Longitude`: Keyword description
- `Zaltitude`: Keyword description
"""
	function SUNLIGHT_HOURS(; DateTimeMinute, Latitude, Longitude, Zaltitude)

		Obs = SolarPosition.Observer(Latitude, Longitude, Zaltitude)
		Tz = TimeZones.TimeZone("Europe/London")

		# SolarPosition.transit_sunrise_sunset(Obs, ZonedDateTime(Dates.year(DateTimeMinute), Dates.month(DateTimeMinute), Dates.day(DateTimeMinute), Tz))

		Tsunrise = SolarPosition.next_sunrise(Obs, ZonedDateTime(Dates.year(DateTimeMinute), Dates.month(DateTimeMinute), Dates.day(DateTimeMinute), Tz))
		Tsunrise_Hour = Dates.hour(Tsunrise)

		Tsunset = SolarPosition.next_sunset(Obs, ZonedDateTime(Dates.year(DateTimeMinute), Dates.month(DateTimeMinute), Dates.day(DateTimeMinute), Tz))
		Tsunset_Hour = Dates.hour(Tsunset)

		T_Hour = Dates.hour(DateTimeMinute)

		if Tsunset_Hour ≥ T_Hour ≥ Tsunrise_Hour
			🎏_Daylight = true
		else
			🎏_Daylight = false
		end

		return 🎏_Daylight
	end  # function: SUNLIGHT_HOURS
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : DAY_NIGHT
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# 	function SUNLIGHT(;ω_SolarTime, Latitude_Radian, δ, Hour)
	# 		ωₛᵤₙₛₑₜ = radiation.ωₛ_SUNSET_HOUR_ANGLE(;Latitude_Radian, δ)

	# 		if ωₛᵤₙₛₑₜ < ω_SolarTime || -ωₛᵤₙₛₑₜ > ω_SolarTime
	# 			return 🎏_Daylight = false
	# 		else
	# 			return 🎏_Daylight = true
	# 		end
	# 	end  # function: DAY_NIGHT
	# # ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION :  N_HOURS_DAYLIGHT
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
	 N_HOURS_DAYLIGHT(; kwargs...) -> Return type

Description of the function

# Keywords

- `ω_SolarTime`: Keyword description
"""
	function N_HOURS_DAYLIGHT(; ω_SolarTime)
		Ndaylight = 2.0 * 24.0 * ω_SolarTime / (2.0 * π)
		return Ndaylight
	end # N_HOURS_DAYLIGHT
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : ω_SOLAR_TIME_ANGLE_HOUR
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	""" Solar time angle, accounts that earth rotates 15ᵒ every hour. Hour angle is negative before solar noon, 0 at solar noon and positive afterwards
	"""
	function ω_SOLAR_TIME_ANGLE_HOUR(; DateTimeMinute, Latitude, Longitude, Zaltitude, ΔT₁, Longitude_LocalTime)

		HourFraction = min(ΔT₁ / (60.0 * 60.0), 1.0)

		# Obs = Observer(Latitude, Longitude, Zaltitude)

		# TimeZone = TimeZones.TimeZone("Europe/London")
		# ZoneDateTimes_Days = ZonedDateTime(Dates.year(DateTimeMinute), Dates.month(DateTimeMinute), Dates.day(DateTimeMinute), TimeZone)

		# Positions = SolarPosition.solar_position(Obs, DateTimeMinute)

		# SolarNoon = SolarPosition.Utilities.next_solar_noon(Obs,ZoneDateTimes_Days)

		# Positions_SolarNoon = SolarPosition.solar_position(Obs, SolarNoon, PSA(), HUGHES())

		# ω_SolarTime = (Positions.azimuth - Positions_SolarNoon.azimuth) * π / 180.0

		# else
		DayOfYear = Dates.dayofyear(DateTimeMinute)
		Hour = Dates.hour(DateTimeMinute)

		B = 2 * π * (DayOfYear - 81) / 364
		Sc = 0.1645 * sin(2.0 * B) - 0.1255 * cos(B) - 0.025 * sin(B)
		# ω_SolarTime  = (((Hour + 0.5) + 0.06667 * (Longitude_LocalTime - Longitude) + Sc ) - 12.0) * π / 12.0
		ω_SolarTime = (((Hour + HourFraction) + 0.06667 * (Longitude_LocalTime - -Longitude) + Sc) - 12.0) * π / 12.0
		# end

		ω₁ = ω_SolarTime - π * HourFraction / 24.0
		ω₂ = ω_SolarTime + π * HourFraction / 24.0

		return ω₁, ω₂
	end #  ω_SOLAR_TIME_ANGLE_HOUR
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Extraterrestrial_radiation
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	* Rₐ [J m-2 second-1] EXTRATERRESTRIAL RADIATION IN THE HOUR (OR SHORTER) PERIOD ,

	INPUT
		* Gsc: [J m⁻² second⁻¹] solar constant = 0.0820 ,
		* Dₑₛ: [m] inverse relative distance Earth-Sun ,
		* δ: [rad] solar declination ,
		* ϕ: [rad] latitude ,
		* ω1 [rad]: solar time angle at beginning of period [rad] ,
		* ω2 [rad]: solar time angle at end of period  (Equation 30).
		* ΔT [hour] time step
		* Longitude_ᴼ : Longitude of the measured site [degrees west of Greenwish]
		* Longitude_Z of the measurement site [degrees west of Greenwich]

	PROCESS
		ω [rad] solar time angle at midpoint of hourly or shorter period [rad]
		ωₛ [rad] sunset hour angle
	"""
	function Rₐ_EXTRATERRESTRIAL_RADIATION_HOURLY(; DateTimeMinute, Gsc, Latitude, Longitude, Longitude_LocalTime, Zaltitude, ΔT₁)

		Latitude_Radian = Latitude * π / 180.0
		DayOfYear = Dates.dayofyear(DateTimeMinute)

		δ_SOLAR_INCLINATION(DayOfYear) = 0.409 * sin(DayOfYear * 2.0 * π / 365.0 - 1.39)
		δ = δ_SOLAR_INCLINATION(DayOfYear)

		ω₁, ω₂ = radiation.ω_SOLAR_TIME_ANGLE_HOUR(; DateTimeMinute, Latitude, Longitude, Zaltitude, ΔT₁, Longitude_LocalTime)

		Dₑₛ_INVERSE_DISTANCE_SUN_EARTH(DayOfYear) = 1.0 + 0.033 * cos(DayOfYear * 2.0 * π / 365.0)
		Dₑₛ = Dₑₛ_INVERSE_DISTANCE_SUN_EARTH(DayOfYear)

		# 🎏_Daylight, T_Hour, Tsunrise, Tsunrise = radiation.SUNLIGHT_HOURS(;DateTimeMinute, Latitude, Longitude, Zaltitude)

		Radₐ = (12.0 * 60 / π) * Gsc * Dₑₛ * ((ω₂ - ω₁) * sin(Latitude_Radian) * sin(δ) + cos(Latitude_Radian) * cos(δ) * (sin(ω₂) - sin(ω₁)))
		return Radₐ
	end  # function: Extraterrestrial_radiation
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Radₛₒ_CLEAR_SKY_RADIATION
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Radₛₒ: [MJ m-2 second-1]: CLEAR-SKY RADIATION.
	Short Wave Radiation on a Clear-Sky Day

	INPUT
	* Zaltitude: [m] Altitude
	*  Radₐ [J m-2 second-1] extraterrestrial radiation
	"""
	function Radₛₒ_CLEAR_SKY_RADIATION(; Radₐ, Zaltitude)
		return Radₛₒ = (0.75 + 2.0E-5 * Zaltitude) * Radₐ
	end  # Radₛₒ_CLEAR_SKY_RADIATION
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Rₙₗ_LONGWAVE RADIATION
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Rₙₗ: [J m-2 second-1] NET OUTGOING LONGWAVE RADIATION.

	INPUT
		* σ: [J K-4 m-2 second-1] Stefan-Boltzmann constant;
		* Temp: [ᵒC] average hourly temperature,
		* Eₐ: [kPa] actual vapour pressure;
		* Radₛᵣ: [J m-2 second-1] measured solar radiation;

	PROCESSES
		* Radₛₒ: [MJ m-2 second7-1]: clear-sky radiation.

		Radₛᵣ/Radₛₒ relative shortwave radiation (limited to ≤ 1.0),
	"""
	function Radₙₗ_LONGWAVE_RADIATION(; σ, Temp, Eₐ, Radₛᵣ, T_Kelvin, Radₛₒ, ϵ = 1.0E-5)
		# if 🎏_Hourly
		# T₁ = (σ * ((T_Kelvin + T_Max)^4 + (T_Kelvin + T_Min)^4) / 2.0)

		# Correction for effect of cloundiness
		Radₙₗ = (σ * (T_Kelvin + Temp)^4) * (0.34 - (0.14 * √Eₐ)) * (1.35 * max(min(Radₛᵣ / (Radₛₒ + ϵ), 1.0), 0.0) - 0.35)
		return Radₙₗ
	end  # function: Rₙₗ_LONGWAVE RADIATION
	# ------------------------------------------------------------------

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Radₙₛ_NET_SHORTWAVE_RADIATION_REFLECTED
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	 Radₙₛ: [J m-2 second-1] INCOMING NET SHORTWAVE RADIATION

	INPUT
		* Radₛᵣ: [J m-2 second-1] measured solar radiation;

	PARAMETER
		* α: [-] albedo or canopy reflection coefficient, which is 0.23 for the hypothetical grass reference crop
	"""
	function Radₙₛ_NET_SHORTWAVE_RADIATION_REFLECTED(; α, Radₛᵣ)
		Radₙₛ = (1.0 - α) * Radₛᵣ
		return Radₙₛ
	end  # function: Rₙₛ_NET_SHORTWAVE_RADIATION
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : Radₙ_NET_RADIATION
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	Rₙ [MJ m-2 second-1] NET RADIATION AT THE CROP SURFACE

	INPUT
		* Radₙₛ: [J m-2 second-1] Incoming net shortwave radiation,
	 	* Radₙₗ: [J m-2 second-1] Outgoing net longwave radiation.
	"""
	function ΔRadₙ_NET_RADIATION(; Radₙₗ, Radₙₛ)
		ΔRadₙ = max(Radₙₛ - Radₙₗ, 0.0)
		return ΔRadₙ
	end  # function: Rₙ_NET_RADIATION
# ------------------------------------------------------------------

end  # module: radiation
# ............................................................


# =============================================================
#		module: ground
# =============================================================
module ground
	using SolarPosition, Dates
	import ..radiation

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : G_SOIL_HEAT_FLUX
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
	G: [MJ m-2 hour-1] SOIL HEAT FLUX DENSITY

	INPUT
		* Rₙ: [MJ m-2 hour-1] measured solar radiation;
	"""
	function G_SOIL_HEAT_FLUX_HOURLY(; DateTimeMinute, Latitude, Longitude, ΔRadₙ, Zaltitude, SoilHeatFlux_Sunlight, SoilHeatFlux_Night)

		🎏_Daylight = radiation.SUNLIGHT_HOURS(; DateTimeMinute, Latitude, Longitude, Zaltitude)

		if 🎏_Daylight
			return G = SoilHeatFlux_Sunlight * ΔRadₙ
		else
			return G = SoilHeatFlux_Night * ΔRadₙ
		end
	end  # function: G_SOIL_HEAT_FLUX
# ------------------------------------------------------------------

end  # module: ground
# ............................................................


end  # module: petFunc
# ............................................................

