# Quick start

## Installing the package

The software is written in Julia language which must be installed on your computer. Julia can be downloaded by using the link [Download Julia .](https://julialang.org/downloads/)

We recommend the [VisualStudioCode ](https://code.visualstudio.com/)as an

Install the package by typing:

```julia
]
add PenmanMonteithHourly
```

or

```julia
]
add https://github.com/AquaPore/PenmanMonteithTimeStep.jl.git
```

or

>

Then to use the package:

```julia
using PenmanMonteithHourly
```

## Running the model with an example

### Step 1

**The following climate input csv data file can be downloaded, and a path will be automatically created.**

```julia
# create a "data/input" directory in the current directory
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT/Timoleague")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT/Timoleague")
isdir(Outputdir) || mkpath(Outputdir)

Csv_path = joinpath(Inputdir, "Timoleague_Climate_Minute.csv")
Csv_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithTimeStep.jl/refs/heads/master/test/Data/INPUT/Timoleague/Timoleague_Climate_Minute.csv"
download(Csv_url, Csv_path)

```

#### Step 2

**The following example input [toml](https://toml.io/en/) file can be downloaded:**

```julia
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT/Timoleague")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT/Timoleague")
isdir(Outputdir) || mkpath(Outputdir)

Toml_path = joinpath(Inputdir, "Timoleague_PetOption.toml")
Toml_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithTimeStep.jl/refs/heads/master/test/Data/INPUT/Timoleague/Timoleague_PetOption.toml"
download(Toml_url, Toml_path)
```

#### Step 3

Run the code, as an option you could modify the [path] of the toml file `Timoleague_PetOption.toml`

```julia
using  PenmanMonteithTimeStep
Testdir = @__DIR__

# The path can be modified
Path_Toml = joinpath(Testdir, "DATA/INPUT/Timoleague/Timoleague_PetOption.toml")

DayHour, DayHour_Reduced, Pet_Obs, Pet_Obs_Reduced, Pet_Sim, Pet_Sim_Reduced = PenmanMonteithTimeStep.PENMAN_MONTEITH_HOURLY_RUN(;Path_Toml);
```
