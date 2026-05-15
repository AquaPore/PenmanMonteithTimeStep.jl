# =============================================================
#		module: Table
# =============================================================
module Table

using Dates: Dates
using CSV: CSV
using Tables: Tables

   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   #		FUNCTION : STRUCT_2_FIELDNAMESs
   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   """
      STRUCT_2_FIELDNAME(N::Int64, Structure) FieldName_Array = propertynames(Structure) N_FieldName = length(FieldName_Array) # Matrix Matrix = fill(0.0, (N, N_FieldName)) i = 1 for FieldName in FieldName_Array Struct_Array = getfield(Structure, FieldName) if isa(Struct_Array, Array) Matrix[1:N, i] = Float64.(Struct_Array[1:N]) else Matrix[1, i] = Float64.(Struct_Array) end i += 1 end # HEADER FieldName_String = fill(""::String, N_FieldName) i = 1 for FieldNames in FieldName_Array FieldName_String[i] = String(FieldNames) i += 1 end return Matrix, FieldName_String end # function STRUCT_2_FIELDNAME -> Return type

   Description of the function

   # Arguments

   - `N::Int64`: Argument description
   - `Structure`: Argument description
   """
   function STRUCT_2_FIELDNAME(N::Int64, Structure)
      FieldName_Array = propertynames(Structure)

      N_FieldName = length(FieldName_Array)

      # Matrix
      Matrix = fill(0.0, (N, N_FieldName))

      i = 1
      for FieldName in FieldName_Array
         Struct_Array = getfield(Structure, FieldName)
         if isa(Struct_Array, Array)
            Matrix[1:N, i] = Float64.(Struct_Array[1:N])
         else
            Matrix[1, i] = Float64.(Struct_Array)
         end
         i += 1
      end

      # HEADER
      FieldName_String = fill(""::String, N_FieldName)
      i = 1
      for FieldNames in FieldName_Array
         FieldName_String[i] = String(FieldNames)
         i += 1
      end

      return Matrix, FieldName_String
   end # function STRUCT_2_FIELDNAME
   # .................................................................


   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   #		FUNCTION : TABLE_PET
   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   """
      TABLE_PET(; kwargs...) -> Return type

   Description of the function

   # Keywords

   - `DayHour`: Keyword description
   - `meteo`: Keyword description
   - `Nmeteo`: Keyword description
   - `Pet_Sim`: Keyword description
   - `Pet_Obs`: Keyword description
   - `path`: Keyword description
   - `flag`: Keyword description
   """
   function TABLE_PET(; DayHour, meteo, Nmeteo, Pet_Sim, Pet_Obs, path, flag)

      Path_Output = joinpath(pwd(), path.Path_Output, path.StationName, path.Filename_Output_TableCsv)
      println("		~~ ", Path_Output, "~~")

      Matrix₁, FieldName_String = Table.STRUCT_2_FIELDNAME(Nmeteo, meteo)

      pushfirst!(FieldName_String, string("Date")) # Table the "Id" at the very begenning
      push!(FieldName_String, string("Pet_Sim")) # Table the "Id" at the very begenning

      if flag.🎏_PetObs
         push!(FieldName_String, string("Pet_Obs")) # Table the "Id" at the very begenning
      end

      if flag.🎏_PetObs
         CSV.write(Path_Output, Tables.table([DayHour Matrix₁ Pet_Sim Pet_Obs]), writeheader=true, header=FieldName_String, bom=true)
      else
         CSV.write(Path_Output, Tables.table([DayHour Matrix₁ Pet_Sim]), writeheader=true, header=FieldName_String, bom=true)
      end
      return nothing
   end  # function: TABLE_PET
   # ------------------------------------------------------------------


   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   #		FUNCTION : TABLE_PET_ΔToutput
   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   """
      TABLE_PET_ΔToutput(; kwargs...) -> Return type

   Description of the function

   # Keywords

   - `DayHour_Reduced`: Keyword description
   - `Pet_Obs_Reduced`: Keyword description
   - `Pet_Sim_Reduced`: Keyword description
   - `path`: Keyword description
   - `flag`: Keyword description
   """
   function TABLE_PET_ΔToutput(; DayHour_Reduced, Pet_Obs_Reduced, Pet_Sim_Reduced, path, flag)

      Path_Output = joinpath(pwd(), path.Path_Output, path.StationName, path.Filename_Output_TableΔTCsv)
      println("		~~ ", Path_Output, "~~")

      if flag.🎏_PetObs
         Header = ["Date", "Pet_Obs", "Pet_Sim"]
         CSV.write(Path_Output, Tables.table([DayHour_Reduced Pet_Obs_Reduced Pet_Sim_Reduced]), writeheader=true, header=Header, bom=true)
      else
         Header = ["Date", "Pet_Sim"]
         CSV.write(Path_Output, Tables.table([DayHour_Reduced Pet_Sim_Reduced]), writeheader=true, header=Header, bom=true)
      end
      return nothing
   end  # function: TABLE_PET
   # ------------------------------------------------------------------

end  # module: Table
# ............................................................
