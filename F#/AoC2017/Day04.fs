[<AutoOpen>]
module Day04

open AoC.Util

let passphraseIsValidPt1 (passphrase:string): bool =
    let words = passphrase.Split(" ")
    let uniqueWords = words |> Set.ofArray
    uniqueWords.Count = words.Length

let passphraseIsValidPt2 passphrase: bool =
    true

let solvePartOne input =
    input |> List.filter passphraseIsValidPt1 |> List.length

let solvePart validator input =
    input |> List.filter validator |> List.length

let solveDay04 isTest: Unit =
    let day = 4
    let puzzleName = "High-Entropy Passphrases"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let solution1 = solvePart passphraseIsValidPt1 input
    printfn $"Part One: {solution1} passphrases are valid"
    let solution2 = solvePart passphraseIsValidPt2 input
    printfn $"Part Two: {solution2} passphrases are valid"
