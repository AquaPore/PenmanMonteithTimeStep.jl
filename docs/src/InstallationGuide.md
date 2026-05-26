# Quick start

## Installing the package

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

Then to use the package:

```julia
using PenmanMonteithHourly
```

## Running the model with examples

### Step 1

**The following climate input csv data file can be downloaded:**

```julia
# create a "data/input" directory in the current directory
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT/Ballycanew")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT/Ballycanew")
isdir(Outputdir) || mkpath(Outputdir)

Csv_path = joinpath(Inputdir, "Ballycanew_Climate_Minute.csv")
Csv_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithTimeStep.jl/refs/heads/master/test/Data/INPUT/Ballycanew/Ballycanew_Climate_Minute.csv"
download(Csv_url, Csv_path)

```

#### Step 2

**The following example input [toml](https://toml.io/en/) file can be downloaded:**

```julia
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT/Ballycanew")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT/Ballycanew")
isdir(Outputdir) || mkpath(Outputdir)

Toml_path = joinpath(Inputdir, "Ballycanew_PetOption.toml")
Toml_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithTimeStep.jl/refs/heads/master/test/Data/INPUT/Ballycanew/Ballycanew_PetOption.toml"
download(Toml_url, Toml_path)
```

#### Step 3

If required Modify the toml [path] to get the correct names of the files if

#### Step 4 $\alpha$

Run the code, as an option you could modify the [path] of the toml file `Ballycanew_PetOption.toml`\

```julia
using  PenmanMonteithTimeStep
Testdir = @__DIR__

# The path can be modified
Path_Toml = joinpath(Testdir, "DATA/INPUT/Ballycanew/Ballycanew_PetOption.toml")

DayHour, DayHour_Reduced, Pet_Obs, Pet_Obs_Reduced, Pet_Sim, Pet_Sim_Reduced = PenmanMonteithTimeStep.PENMAN_MONTEITH_HOURLY_RUN(;Path_Toml);
```
