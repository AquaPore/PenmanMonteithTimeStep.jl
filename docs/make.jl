using PenmanMonteithTimeStep
using Documenter

DocMeta.setdocmeta!(PenmanMonteithTimeStep, :DocTestSetup, :(using PenmanMonteithTimeStep); recursive=true)

makedocs(;
    modules=[PenmanMonteithTimeStep],
    authors="“AquaPore” <“pollacco.water@gmail.com”> and contributors",
    sitename="PenmanMonteithTimeStep.jl",
    format=Documenter.HTML(;
        canonical="https://AquaPore.github.io/PenmanMonteithTimeStep.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/AquaPore/PenmanMonteithTimeStep.jl",
    devbranch="master",
)
