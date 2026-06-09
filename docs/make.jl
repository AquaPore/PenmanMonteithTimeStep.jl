using PenmanMonteithTimeStep
using Documenter

DocMeta.setdocmeta!(PenmanMonteithTimeStep, :DocTestSetup, :(using PenmanMonteithTimeStep); recursive=true)

makedocs(;
    modules=[PenmanMonteithTimeStep],
    authors="AquaPore <pollacco.water@gmail.com> and contributors",
    sitename="PenmanMonteithTimeStep.jl",
    warnonly = [:missing_docs], # otherwise making docs will throw on missing docstrings
    format=Documenter.HTML(;
        canonical="https://AquaPore.github.io/PenmanMonteithTimeStep.jl",
        edit_link="master",
        assets=String[], ),
    pages=[
        "KeyFeatures.md",
        "Quickstart" => [
            "Installation" => "InstallationGuide.md",
            "Input output" => "InputOutputData.md",],

        "Model" => [
            "PenmanMonteith Equations" => "Equations.md",
        ],
    ],
)


deploydocs(;
    repo="github.com/AquaPore/PenmanMonteithTimeStep.jl",
    devbranch="master",
)

# checkdocs=:exports