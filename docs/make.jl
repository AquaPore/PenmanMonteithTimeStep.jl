using Documenter
# using PenmanMonteithTimeStep

makedocs(
    sitename = "PenmanMonteithTimeStep",
    format = Documenter.HTML(),
    modules = [PenmanMonteithTimeStep]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
