# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    AbstractSpatialObject{T,N}

Spatial object in a `N`-dimensional space with coordinates of type `T`.
"""
abstract type AbstractSpatialObject{T,N} end

"""
    domain(object)

Return underlying domain of spatial `object`.
"""
domain(object) = object.domain

"""
    ndims(object)

Return the number of dimensions of domain underlying `object`.
"""
Base.ndims(::AbstractSpatialObject{T,N}) where {N,T} = N

"""
    coordtype(object)

Return the coordinate type of `object`.
"""
coordtype(::AbstractSpatialObject{T,N}) where {N,T} = T

"""
    coordnames(object)

Return the name of the coordinates in `object`.
"""
coordnames(object::AbstractSpatialObject{T,N}) where {N,T} = ntuple(i -> Symbol(:x,i), N)

"""
    npoints(object)

Return the number of points in `object`.
"""
npoints(object::AbstractSpatialObject) = npoints(domain(object))

"""
    coordinates(object, location)

Return the coordinates of the `location` in the `object`.
"""
function coordinates(object::AbstractSpatialObject{T,N},
                     location::Int) where {N,T}
  x = MVector{N,T}(undef)
  coordinates!(x, object, location)
  x
end

"""
    coordinates(object, locations)

Return the coordinates of `locations` in the `object`.
"""
function coordinates(object::AbstractSpatialObject{T,N},
                     locations::AbstractVector{Int}) where {N,T}
  X = Matrix{T}(undef, N, length(locations))
  coordinates!(X, object, locations)
  X
end

"""
    coordinates(object)

Return the coordinates of all locations in `object`.
"""
coordinates(object::AbstractSpatialObject) = coordinates(object, 1:npoints(object))

"""
    coordinates!(buff, object, locations)

Non-allocating version of [`coordinates`](@ref)
"""
function coordinates!(buff::AbstractMatrix, object::AbstractSpatialObject,
                      locations::AbstractVector{Int})
  for j in 1:length(locations)
    coordinates!(view(buff,:,j), object, locations[j])
  end
end

"""
    coordinates!(buff, object, location)

Non-allocating version of [`coordinates`](@ref).
"""
coordinates!(buff::AbstractVector, object::AbstractSpatialObject, location::Int) =
  coordinates!(buff, domain(object), location)
