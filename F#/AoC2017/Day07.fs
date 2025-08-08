[<AutoOpen>]
module Day07

open AoC.Util

let solvePartOne input =
    1

let solvePartTwo input =
    2

let solveDay07 isTest: Unit =
    let day = 07
    let puzzleName = "Recursive Circus"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let solution1 = solvePartOne input
    printfn $"Part One: {solution1}"
    let solution2 = solvePartTwo input
    printfn $"Part Two: {solution2}"
