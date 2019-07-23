@testset "Problems" begin
  data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
  data3D = readgeotable(joinpath(datadir,"data3D.tsv"), delim='\t')
  grid2D = RegularGrid{Float64}(100,100)
  grid3D = RegularGrid{Float64}(100,100,100)

  @testset "Estimation" begin
    # test basic problem interface
    problem3D = EstimationProblem(data3D, grid3D, :value)
    @test data(problem3D) == data3D
    @test domain(problem3D) == grid3D
    @test variables(problem3D) == Dict(:value => Float64)

    # dimension mismatch
    @test_throws AssertionError EstimationProblem(data3D, grid2D, :value)

    # show methods
    problem2D = EstimationProblem(data2D, grid2D, :value)
    @test sprint(show, problem2D) == "2D EstimationProblem"
    @test sprint(show, MIME"text/plain"(), problem2D) == "2D EstimationProblem\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×100 RegularGrid{Float64,2}\n  variables: value (Float64)"

    if visualtests
      gr(size=(800,800))
      @plottest plot(problem2D,ms=2) joinpath(datadir,"EstimationProblem2D.png") !istravis
    end
  end

  @testset "Simulation" begin
    # test basic problem interface
    problem3D = SimulationProblem(data3D, grid3D, :value, 100)
    @test data(problem3D) == data3D
    @test domain(problem3D) == grid3D
    @test variables(problem3D) == Dict(:value => Float64)
    @test hasdata(problem3D)
    @test nreals(problem3D) == 100

    # dimension mismatch
    @test_throws AssertionError SimulationProblem(data3D, grid2D, :value, 100)

    # specify type of variable explicitly
    problem = SimulationProblem(data3D, grid3D, :value => Float64, 100)
    @test variables(problem) == Dict(:value => Float64)

    # add variable not present in spatial data
    problem = SimulationProblem(data3D, grid3D, (:value => Float64, :other => Int), 100)
    @test variables(problem) == Dict(:value => Float64, :other => Int)
    @test isempty(datamap(problem)[:other])

    # infer type of variables in spatial data whenever possible
    problem = SimulationProblem(data3D, grid3D, (:value, :other => Int), 100)
    @test variables(problem) == Dict(:value => Float64, :other => Int)
    @test isempty(datamap(problem)[:other])

    # constructors without spatial data require variables with types
    problem = SimulationProblem(grid3D, :value => Float64, 100)
    @test variables(problem) == Dict(:value => Float64)
    @test isempty(datamap(problem)[:value])
    @test_throws MethodError SimulationProblem(grid3D, :value, 100)

    # show methods
    problem2D = SimulationProblem(data2D, grid2D, :value, 100)
    @test sprint(show, problem2D) == "2D SimulationProblem (conditional)"
    @test sprint(show, MIME"text/plain"(), problem2D) == "2D SimulationProblem (conditional)\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×100 RegularGrid{Float64,2}\n  variables: value (Float64)\n  N° reals:  100"

    if visualtests
      gr(size=(800,800))
      @plottest plot(problem2D,ms=2) joinpath(datadir,"SimulationProblem2D.png") !istravis
    end
  end

  @testset "Learning" begin
    # TODO:
  end
end
