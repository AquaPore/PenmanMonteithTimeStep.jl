## Quick start

### Installing the package

Install the package by typing:

```julia
]
add PenmanMonteithHourly
```

The instructions are found in [Manual](https://aquapore.github.io/PenmanMonteithHourly.jl/stable/)

Then to use it:

```julia
using PenmanMonteithHourly
```

### Running the model with examples

#### Step 1 :

**The following climate input csv data file can be downloaded:**

```julia
# create a "data/input" directory in the current directory
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT")
isdir(Outputdir) || mkpath(Outputdir)

Csv_path = joinpath(Inputdir, "Ballycanew_Climate_Minute.csv")
Csv_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithHourly.jl/refs/heads/main/test/Data/INPUT/Ballycanew/Ballycanew_Climate_Minute.csv"
download(Csv_url, Csv_path)

```

#### Step 2 :

**The following example input [toml](https://toml.io/en/) file can be downloaded:**

```julia
Testdir = @__DIR__

# The path can be modified
Inputdir = joinpath(Testdir, "DATA/INPUT")
isdir(Inputdir) || mkpath(Inputdir)

Outputdir = joinpath(Testdir, "DATA/OUTPUT")
isdir(Outputdir) || mkpath(Outputdir)

Toml_path = joinpath(Inputdir, "Ballycanew_PetOption.toml")
Toml_url = "https://raw.githubusercontent.com/AquaPore/PenmanMonteithHourly.jl/refs/heads/main/test/Data/INPUT/Ballycanew/Ballycanew_PetOption.toml"
download(Toml_url, Toml_path)
```

#### Step 3 :

Modify the toml [path] to get the correct names of the files

#### Step 4 :

Run the code

```
Path_Toml = raw"D:\JOE\MAIN\MODELS\PenmanMonteithHourly.jl\DATA\INPUT\Timoleague\Timoleague_PetOption.toml"

DayHour, DayHour_Reduced, Pet_Obs, Pet_Obs_Reduced, Pet_Sim, Pet_Sim_Reduced = PenmanMonteithHourly.PENMAN_MONTEITH_HOURLY_RUN(;Path_Toml, α = 0.23, 🎏_Debug=false);
```
