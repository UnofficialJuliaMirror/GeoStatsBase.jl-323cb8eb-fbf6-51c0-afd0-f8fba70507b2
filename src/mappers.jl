# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    AbstractMapper

A mapping strategy for mapping spatial data onto a domain.
"""
abstract type AbstractMapper end

"""
    map(spatialdata, domain, targetvars, mapper)

Map the `targetvars` in `spatialdata` to `domain` with `mapper`.
"""
Base.map(::AbstractData, ::AbstractDomain,
         ::NTuple{N,Symbol}, ::AbstractMapper) where {N} = @error "not implemented"

#------------------
# IMPLEMENTATIONS
#------------------
include("mappers/nearest_mapper.jl")
include("mappers/copy_mapper.jl")
