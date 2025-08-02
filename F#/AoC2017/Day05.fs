[<AutoOpen>]
module Day05

open AoC.Util

let solvePartOne (input: array<int>) =
    let mutable ptr = 0
    let mutable stepCount = 0

    while ptr >= 0 && ptr < input.Length do
        let jump = input[ptr]
        input[ptr] <- jump + 1
        ptr <- ptr + jump
        stepCount <- stepCount + 1
    stepCount

let solvePartTwo input =
    2

let solveDay05 isTest: Unit =
    let day = 5
    let puzzleName = "A Maze of Twisty Trampolines, All Alike"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true |> List.map(fun line -> int line) |> Array.ofList

    let solution1 = solvePartOne input
    printfn $"Part One: the program escapes after {solution1} steps"
    let solution2 = solvePartTwo input
    printfn $"Part Two: {solution2}"
