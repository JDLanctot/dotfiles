# ENV["JULIA_NUM_THREADS"] = 8
ENV["EDITOR"] = "nvim"
ENV["PYTHON"] = "/home/toofaeded/anaconda3/bin/python3"
#using Reduce
#@force using Reduce.Algebra
using OhMyREPL
using Revise
using BenchmarkTools, SyntaxTree

# Check if we are in a project directory with a Project.toml file
if isfile("Project.toml")
    # Activate and instantiate the project
    using Pkg
    Pkg.activate(".")
    Pkg.instantiate()
end


cdpkg(pkg) = cd(dirname(Base.find_package(string(pkg))))

macro cdpkg(pkg)
    cdpkg(pkg)
    return nothing
end
