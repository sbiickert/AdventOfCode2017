[<AutoOpen>]
module Day03

open AoC.Util
open AoC.Geometry
open AoC.Grid

let valueToLeft (grid:Grid) (pos:Position): int64 =
    let posLeft = Position.turn RotationDirection.CCW pos |> Position.moveForward 1
    Grid.getInteger posLeft.coord grid

let solvePartOne input =
    let mutable grid = mkHGrid "0" AdjacencyRule.Queen
    let mutable loc = Coord.origin
    let mutable pos = mkPos loc Direction.S

    for current in 1 .. input do
        grid <- Grid.setValue pos.coord (GridData.Value current) grid
        if valueToLeft grid pos = 0 then
            pos <- Position.turn RotationDirection.CCW pos
        loc <- pos.coord
        pos <- Position.moveForward 1 pos
    
    Coord.manhattanDistance loc Coord.origin

let sumOfNeighbors coord grid: int64 =
    Grid.neighbors coord grid
        |> List.map(fun c -> Grid.getInteger c grid)
        |> List.sum

let solvePartTwo input =
    let mutable grid = mkHGrid "0" AdjacencyRule.Queen
    let mutable pos = mkPos Coord.origin Direction.S
    grid <- Grid.setValue pos.coord (GridData.Value 1) grid
    let mutable currentSum = 1L

    while currentSum <= input do
        if valueToLeft grid pos = 0 then
            pos <- Position.turn RotationDirection.CCW pos
        pos <- Position.moveForward 1 pos
        currentSum <- sumOfNeighbors pos.coord grid
        grid <- Grid.setValue pos.coord (GridData.Value currentSum) grid
 
    currentSum

let solveDay03 isTest: Unit =
    let day = 3
    let puzzleName = "Spiral Memory"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readGroupedInput inputName

    let number = int input[0].Head

    let solution1 = solvePartOne number
    printfn $"Part One: the Manhattan Distance to the center from {number} is {solution1}"
    let solution2 = solvePartTwo number
    printfn $"Part Two: the first number bigger than {number} is {solution2}"
