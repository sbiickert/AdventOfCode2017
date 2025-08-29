[<AutoOpen>]
module Day09

open AoC.Util

let solve (input:string) =
    let mutable depth = 0
    let mutable score = 0
    let mutable ptr = 0
    let mutable inGarbage = false
    let mutable garbageCount = 0

    let stream = input.ToCharArray()
    while ptr < stream.Length do
        match stream[ptr] with
            | '!' -> 
                ptr <- ptr + 1
            | '>' when inGarbage -> 
                inGarbage <- false
            | '{' when not inGarbage -> 
                depth <- depth + 1
            | '}' when not inGarbage ->
                score <- score + depth
                depth <- depth - 1
            | '<' when not inGarbage ->
                inGarbage <- true
            | _ when inGarbage ->
                garbageCount <- garbageCount + 1
            | _ -> ()

        ptr <- ptr + 1            

    score,garbageCount

let solveDay09 isTest: Unit =
    let day = 09
    let puzzleName = "Stream Processing"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = (readGroupedInput inputName)[0]

    let solution1,solution2 = solve input.Head
    printfn $"Part One: the total score is {solution1}"
    printfn $"Part Two: the garbage count is {solution2}"
