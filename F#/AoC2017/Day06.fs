[<AutoOpen>]
module Day06

open AoC.Util

let mkState (registers: int array): string =
    registers
    |> Array.map(fun i -> i.ToString()) 
    |> String.concat ""

let findIndexOfFirstLargestRegister (registers: int array):int =
    let max = registers |> Array.max
    registers |> Array.findIndex (fun v -> v = max)

let allocateBlocks (registers: int array):unit =
    let mutable ptr = findIndexOfFirstLargestRegister registers
    let mutable pile = registers[ptr]
    registers[ptr] <- 0
    for i in 1 .. pile do
        ptr <- AoC.Util.wrapIndex registers.Length (ptr+1)
        registers[ptr] <- registers[ptr] + 1

let solve (registers: int array): int * int =
    let mutable stateTracker = Map<string,int> []
    let mutable state = mkState registers
    let mutable cycle = 0

    while stateTracker.ContainsKey state = false do
        stateTracker <- stateTracker.Add (state, cycle)
        allocateBlocks registers
        cycle <- cycle + 1
        state <- mkState registers

    cycle, cycle - stateTracker[state]

let solveDay06 isTest: Unit =
    let day = 6
    let puzzleName = "Memory Reallocation"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let registers = input.Head.Split("\t") |> Array.map(fun s -> int s)

    let solution1, solution2 = solve registers
    printfn $"Part One: the repeat was found at cycle {solution1}"
    printfn $"Part Two: the length of the infinite loop is {solution2}"
