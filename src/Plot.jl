# =============================================================
#		module: Plot
# =============================================================
module Plot
using CairoMakie, Dates

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#		FUNCTION : PLOT_PET
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""
    PLOT_PET(; kwargs...) -> Return type

Description of the function

# Keywords

- `∑Pet_Obs_Reduced`: Keyword description
- `∑Pet_Sim_Reduced`: Keyword description
- `DayHour_Reduced`: Keyword description
- `Nmeteo_Reduced`: Keyword description
- `flag`: Keyword description
- `path`: Keyword description
- `output`: Keyword description
- `Pet_Obs_Reduced`: Keyword description
- `Pet_Sim_Reduced`: Keyword description
"""
function PLOT_PET(; ∑Pet_Obs_Reduced, ∑Pet_Sim_Reduced, DayHour_Reduced, Nmeteo_Reduced, flag, path, output, Pet_Obs_Reduced, Pet_Sim_Reduced)

   Line = range(0.0, stop=maximum(Pet_Obs_Reduced), length=100) 

   Step = Int64(ceil(Nmeteo_Reduced / 30))
   X_Ticks = 1:Step:Nmeteo_Reduced
   Time_Dates = Date.(DayHour_Reduced[X_Ticks])

   # Activating the figure
   CairoMakie.activate!(type="svg", pt_per_unit=0.5)
   Fig = Figure(size=(600, 450), font="Sans", titlesize=30, xlabelsize=20, ylabelsize=20, labelsize=30, fontsize=20)

   if flag.🎏_PetObs
      Axis_1 = Axis(
         Fig[1, 1],
         title=" Penman-Monteith ΔTstep= $(output.ΔT_Output) seconds",
         yticklabelcolor=:black,
         yaxisposition=:left,
         rightspinecolor=:black,
         ytickcolor=:black,
         xlabel=L"$PET_{Sim}$ $[mm]$",
         ylabel=L"$PET_{Obs}$ $[mm]$",
         xgridvisible=false,
         ygridvisible=false,
         width=400,
         height=400,
      )

      scatter!(Axis_1, Pet_Sim_Reduced, Pet_Obs_Reduced, color=:blue)
      lines!(Axis_1, Line, Line, color=:grey, linestyle=:dash, linewidth=2)

      Axis_2 = Axis(
         Fig[2, 1],
         title=" Penman-Monteith  ΔTstep= $(output.ΔT_Output) second",
         yticklabelcolor=:black,
         yaxisposition=:left,
         rightspinecolor=:black,
         ytickcolor=:black,
         xlabel=L"$Date$ ",
         ylabel=L"$ ∑PET [mm]$ ",
         xgridvisible=false,
         ygridvisible=false,
         width=800,
         height=200,
         xticklabelrotation=π / 2.0,
      )

      Axis_2.xticks = (X_Ticks, string.(Time_Dates))
      hidexdecorations!(Axis_2, grid=false, ticks=true, ticklabels=true)
      lines!(Axis_2, 1:1:Nmeteo_Reduced, ∑Pet_Obs_Reduced, linewidth=2, color=:red, label=L"$∑PET_{Obs}$ $[mm]$")
      lines!(Axis_2, 1:1:Nmeteo_Reduced, ∑Pet_Sim_Reduced, linewidth=2, color=:blue, label=L"$∑PET_{Sim}$ $[mm]$")
   end

   Axis_3 = Axis(
      Fig[3, 1],
      yticklabelcolor=:black,
      yaxisposition=:left,
      rightspinecolor=:black,
      ytickcolor=:black,
      xlabel=L"$Date$ ",
      ylabel=L"$PET [mm]$ ",
      xgridvisible=false,
      ygridvisible=false,
      width=800,
      height=200,
      xticklabelrotation=π / 2.0,
   )

   Axis_3.xticks = (X_Ticks, string.(Time_Dates))

   if flag.🎏_PetObs
      lines!(Axis_3, 1:1:Nmeteo_Reduced, Pet_Obs_Reduced, linewidth=2, color=(:blue, 0.6), label=L"$PET_{Obs}$ ")
   end

   lines!(Axis_3, 1:1:Nmeteo_Reduced, Pet_Sim_Reduced, linewidth=2, color=:red, label=L"$PET_{Sim}$")

   Leg = Legend(Fig[4, 1], Axis_3, framevisible=true, tellheight=true, tellwidth=true, labelsize=25, nbanks=2)

   colgap!(Fig.layout, 15)
   rowgap!(Fig.layout, 15)
   resize_to_layout!(Fig)
   trim!(Fig.layout)
   display(Fig)

   Path_Output = joinpath(pwd(), path.Path_Output, path.StationName, path.Filename_Output_Plot)
   CairoMakie.save(Path_Output, Fig)
   println("		~~ ", Path_Output, "~~")

   return nothing
end  # function: PLOT_PET
# ------------------------------------------------------------------

end  # module: Plot
# ............................................................
