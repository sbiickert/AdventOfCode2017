[<AutoOpen>]
module Day04

open AoC.Util

let passphraseIsValidPt1 (passphrase:string): bool =
    let words = passphrase.Split(" ")
    let uniqueWords = words |> Set.ofArray
    uniqueWords.Count = words.Length

let sortChars (word:string):string =
    let chars = word.ToCharArray() |> Array.sort
    new string(chars)

let areAnagrams (word1:string, word2:string): bool =
    word1.Length = word2.Length && sortChars word1 = sortChars word2

let passphraseIsValidPt2 passphrase: bool =
    passphraseIsValidPt1 passphrase &&
        let words = passphrase.Split(" ")
        let anagramCount = AoC.Util.combinations words |> Seq.filter areAnagrams |> Seq.length
        anagramCount = 0

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
