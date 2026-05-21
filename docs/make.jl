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
        assets=String[],
    ),
    pages=[
        "Home" => "KeyFeatures.md",

        "Quickstart" => [
            "Installation Guide & examples" => "InstallationGuide.md",
            "Input output" => "Input Output Data.md"],

        "Model" => [
            "PenmanMonteith Equations" => "Equation.md"
        ]
    ],
)


deploydocs(;
    repo="github.com/AquaPore/PenmanMonteithTimeStep.jl",
    devbranch="master",
)

# checkdocs=:exports