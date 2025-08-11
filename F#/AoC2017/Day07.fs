[<AutoOpen>]
module Day07

open AoC.Util
open System.Text.RegularExpressions

type WeightAndChildren = 
    {
        weight: int
        children: List<string>
    }

let rec totalWeight (program:string) (map:Map<string,WeightAndChildren>): int =
    let wc = map[program]
    let childWeight = wc.children |> List.fold(fun acc elem -> acc + totalWeight elem map) 0
    wc.weight + childWeight

let solvePartOne (map:Map<string,WeightAndChildren>): string =
    let allPrograms = map.Keys |> Set.ofSeq
    let allChildren =
        map.Values |> Seq.map(fun wc -> wc.children) |> Seq.collect id |> Set.ofSeq
    allChildren |> Set.difference allPrograms |> Set.toList |> List.head

let solvePartTwo (map:Map<string,WeightAndChildren>): (string * int) =
    
    "bob",2

let buildMap input =
    let mutable map = Map<string,WeightAndChildren> []
    let rx = Regex(@"(\w+) \((\d+)\)( -> (.+))?")
    input |> List.map (fun (line:string) ->
        let m = rx.Match(line).Groups
        let name = m[1].Value
        let weight = int m[2].Value
        let children =
            if m[3].Success then
                m[4].Value.Split(", ") |> List.ofArray
            else
                []
        map <- map.Add (name, {weight=weight; children=children})
    ) |> ignore
    map

let solveDay07 isTest: Unit =
    let day = 07
    let puzzleName = "Recursive Circus"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let map = buildMap input

    let solution1 = solvePartOne map
    printfn $"Part One: the program at the bottom is {solution1}"
    let solution2Name,solution2Weight = solvePartTwo map
    printfn $"Part Two: the program {solution2Name} should weigh {solution2Weight}"
