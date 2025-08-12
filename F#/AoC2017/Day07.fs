[<AutoOpen>]
module Day07

open AoC.Util
open System.Text.RegularExpressions

type WeightAndChildren = 
    {
        weight: int
        totalWeight: int
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

let applyTotalWeight (map:Map<string,WeightAndChildren>): Map<string,WeightAndChildren> =
    let mutable modifiedMap = map
    for key in map.Keys do
        let tw = totalWeight key map
        modifiedMap <- modifiedMap.Remove key
        modifiedMap <- modifiedMap.Add (key, {map[key] with totalWeight=tw})
    modifiedMap

let mkParentMap (map:Map<string,WeightAndChildren>): Map<string,string> =
    let mutable parentMap = Map<string,string>[]
    for key in map.Keys do
        for child in map[key].children do
            parentMap <- parentMap.Add (child, key)
    parentMap

let majorityWeight weights =
    weights
    |> Seq.countBy id
    |> Seq.maxBy snd
    |> fst

let solvePartTwo (map:Map<string,WeightAndChildren>): (string * int) =
    let mapTW = applyTotalWeight map
    let parentMap = mkParentMap map

    map.Keys 
    |> Seq.filter (fun program -> Map.containsKey program parentMap) // Eliminate the base program
    |> Seq.map (fun program -> 
        let siblings = mapTW[parentMap[program]].children
        let majorityWeightInFamily = 
            siblings
            |> List.map (fun sib -> mapTW[sib].totalWeight)
            |> majorityWeight
        let children = mapTW[program].children
        let childrenWeighTheSame =
            children
            |> List.map (fun child -> mapTW[child].totalWeight)
            |> AoC.Util.frequencyMap
            |> Map.count = 1
        let correctWeight =
            if childrenWeighTheSame && mapTW[program].totalWeight <> majorityWeightInFamily then
                mapTW[program].weight - (mapTW[program].totalWeight - majorityWeightInFamily)
            else 0
        program,correctWeight
    )
    |> Seq.filter (fun (program,weight) -> weight <> 0) 
    |> Seq.head

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
        map <- map.Add (name, {weight=weight; totalWeight=0; children=children})
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
