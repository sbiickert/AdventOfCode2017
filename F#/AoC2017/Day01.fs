[<AutoOpen>]
module Day01

open AoC.Util

let solvePart (input:int array) (lookahead:int) =
    input
    |> Array.mapi (fun index number ->
        let offset = (index + lookahead) % input.Length
        if number = input[offset] then
            number
        else
            0
        )
    |> Array.sum

let solveDay01 isTest: Unit =
    let day = 1
    let puzzleName = "Inverse Captcha"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readGroupedInput inputName

    let str = input[0].Head
    let nums = str |> Seq.map (fun c -> c.ToString() |> int) |> Seq.toArray

    let solution1 = solvePart nums 1
    printfn $"Part One: the captcha is {solution1}"
    let solution2 = solvePart nums (nums.Length / 2)
    printfn $"Part Two: the captcha is {solution2}"
