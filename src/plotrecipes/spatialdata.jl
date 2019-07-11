# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(sdata::AbstractData; variables=nothing)
  # retrieve underlying domain
  sdomain = domain(sdata)

  # valid variables
  vars = GeoStatsBase.variables(sdata)
  validvars = sort([var for (var, V) in vars if V <: Number])

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # shared plot specs
  layout --> length(variables)

  for (i, var) in enumerate(variables)
    # retrieve valid values
    vals = map(1:npoints(sdata)) do ind
      if isvalid(sdata, ind, var)
        sdata[ind,var]
      else
        NaN
      end
    end
    @series begin
      subplot := i
      title --> string(var)
      legend --> false
      sdomain, vals
    end
  end
end
