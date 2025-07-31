[<AutoOpen>]
module Day02

open AoC.Util

let solvePartOne spreadsheet =
    spreadsheet
        |> List.map(fun row -> row |> Array.sort)
        |> List.map(fun row -> row[row.Length-1] - row[0])
        |> List.sum

let solvePartTwo spreadsheet =
    let divisiblePairs = 
        spreadsheet
            |> List.map(fun row -> row |> Array.sortDescending)
            |> List.map(fun row ->
                AoC.Util.combinations row
                    |> List.filter(fun (a,b) -> a % b = 0) |> List.head)
    divisiblePairs
        |> List.map(fun (a,b) -> a / b)
        |> List.sum

let solveDay02 isTest: Unit =
    let day = 2
    let puzzleName = "Corruption Checksum"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readGroupedInput inputName

    let spreadsheet =
        input[0]
        |> List.map(fun line -> line.Split "\t" |> Array.map(fun s -> int s))

    let solution1 = solvePartOne spreadsheet
    printfn $"Part One: the spreadsheet checksum is {solution1}"
    let solution2 = solvePartTwo spreadsheet
    printfn $"Part Two: the sum of the row results is {solution2}"
