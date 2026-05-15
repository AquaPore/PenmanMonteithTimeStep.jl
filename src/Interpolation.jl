# =============================================================
#		module: timestep
# =============================================================
module Interpolation

using Dates

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : TIME INTERPOLATION
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""
		TIME_INTERPOLATION

	Interpolated PET at the time step of interest

	# Keywords
	- `Nmeteo`: Number of meteorological data
	- `ΔT`: Time step
	- `Pet_Sim`: Potential Evapotranspiration simulated
	- `Pet_Obs`: Potential Evapotranspiration simulated
	- `ΔT_Output`: Time step of output
	- `DayHour`: Dates
	"""
	function TIME_INTERPOLATION(; Nmeteo, ΔT, Pet_Sim, Pet_Obs, ΔT_Output, DayHour)

		# Cumulating observed time
		∑T = fill(0.0::Float64, Nmeteo)
		∑Pet_Sim = fill(0.0::Float64, Nmeteo)
		∑Pet_Obs = fill(0.0::Float64, Nmeteo)

		∑T[1] = 0
		∑Pet_Sim[1] = Pet_Sim[1]
		∑Pet_Obs[1] = Pet_Obs[1]
		for iT ∈ 2:Nmeteo
			∑T[iT] = ∑T[iT-1] + ΔT[iT]
			∑Pet_Sim[iT] = ∑Pet_Sim[iT-1] + Pet_Sim[iT]
			∑Pet_Obs[iT] = ∑Pet_Obs[iT-1] + Pet_Obs[iT]
		end

		# New ∑time step
		∑T_Reduced = []
		DayHour_Reduced = []
		append!(∑T_Reduced, 0::Int64)
		push!(DayHour_Reduced, DayHour[1])

		🎏Break = false
		while !(🎏Break)
			if ∑T_Reduced[end] + ΔT_Output > ∑T[end]
				🎏Break = true
				break
			else
				append!(∑T_Reduced, ∑T_Reduced[end] + ΔT_Output)
				push!(DayHour_Reduced, DayHour_Reduced[end] + Second(ΔT_Output))
				🎏Break = false
			end # if
		end # while
		Nmeteo_Reduced = length(∑T_Reduced)

		∑Pet_Obs_Reduced, Pet_Obs_Reduced = LINEAR_INTERPOLATION(; ∑T, ∑T_Reduced, ∑obs=∑Pet_Obs)
		∑Pet_Sim_Reduced, Pet_Sim_Reduced = LINEAR_INTERPOLATION(; ∑T, ∑T_Reduced, ∑obs=∑Pet_Sim)

	return ∑Pet_Obs_Reduced, ∑Pet_Sim_Reduced, DayHour_Reduced, Nmeteo_Reduced, Pet_Obs_Reduced, Pet_Sim_Reduced
	end  # function: TIMESETP
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : LINEAR_INTERPOLATION
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"""
	 LINEAR_INTERPOLATION(; kwargs...) -> Return type

Description of the function

# Keywords

- `∑T`: Keyword description
- `∑T_Reduced`: Keyword description
- `∑obs`: Keyword description
"""
	function LINEAR_INTERPOLATION(; ∑T, ∑T_Reduced, ∑obs)
		N = length(∑T)
		Nreduced = length(∑T_Reduced)
		∑obs_Reduced = fill(0.0::Float64, Nreduced)

		for iT_Reduced ∈ 1:Nreduced
			iT_X = 2
			🎏Break = false
			while !(🎏Break)
				if (∑T[iT_X-1] ≤ ∑T_Reduced[iT_Reduced] ≤ ∑T[iT_X]) || (iT_X == N)
					🎏Break = true
					break
				else
					iT_X += 1
					🎏Break = false
				end # if
			end # while

			# Building a regression line which passes from POINT1(∑T[iT_X], ∑Pet_Sim[iT_Pr]) and POINT2: (∑T[iT_Pr+1], ∑Pet_Sim[iT_Pr+1])
			Intercept, Slope = POINTS_2_SlopeIntercept(∑T[iT_X-1], ∑obs[iT_X-1], ∑T[iT_X], ∑obs[iT_X])
			∑obs_Reduced[iT_Reduced] = Slope * ∑T_Reduced[iT_Reduced] + Intercept
		end # for iT = 1:Nmeteo_Reduced

		Obs_Reduced = fill(0.0::Float64, Nreduced)
		Obs_Reduced[1] = ∑obs_Reduced[1]

		for iT_Reduced ∈ 2:Nreduced
			Obs_Reduced[iT_Reduced] = ∑obs_Reduced[iT_Reduced] - ∑obs_Reduced[iT_Reduced-1]
		end

	return ∑obs_Reduced, Obs_Reduced
	end  # function: LINEAR_INTERPOLATION
	# ------------------------------------------------------------------


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	#		FUNCTION : POINTS_2_SlopeIntercept
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	"""POINTS_2_SlopeIntercept
	From Point1 [X1, Y1] and point2 [X2, Y2] compute Y = Slope.X₀ + Intercept
	"""
	function POINTS_2_SlopeIntercept(X1, Y1, X2, Y2)
		Slope = (Y2 - Y1) / (X2 - X1 + eps())
		Intercept = (Y1 * X2 - X1 * Y2) / (X2 - X1)
	return Intercept, Slope
	end # POINTS_2_SlopeIntercept
	#...................................................................

end  # module: timestep
# ............................................................
