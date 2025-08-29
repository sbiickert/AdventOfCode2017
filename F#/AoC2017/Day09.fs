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
        if stream[ptr] = '!' then
            ptr <- ptr + 2
        elif inGarbage then
            if stream[ptr] = '>' then inGarbage <- false
            else garbageCount <- garbageCount + 1
            ptr <- ptr + 1
        else
            match stream[ptr] with
                | '{' -> depth <- depth + 1
                | '}' -> 
                    score <- score + depth
                    depth <- depth - 1
                | '<' -> inGarbage <- true
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
