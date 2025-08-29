[<AutoOpen>]
module Day08

open AoC.Util
open System.Text.RegularExpressions

type Condition =
    {
        reg:string
        comp:string
        value:int
    }

type Instruction = 
    {
        reg:string
        dir:string
        value:int
        cond:Condition
    }

let initRegisters instructions =
    let mutable registers = Map<string,int> []
    for i in instructions do
        registers <-
            if Map.containsKey i.reg registers then
                registers
            else
                registers.Add (i.reg, 0)
        registers <-
            if Map.containsKey i.cond.reg registers then
                registers
            else
                registers.Add (i.cond.reg, 0)
    registers

let evalCondition (registers:Map<string,int>) (condition:Condition) =
    let testValue = registers[condition.reg]
    match condition.comp with
        | "==" -> testValue = condition.value
        | "!=" -> testValue <> condition.value
        | "<"  -> testValue < condition.value
        | ">"  -> testValue > condition.value
        | "<=" -> testValue <= condition.value
        | ">=" -> testValue >= condition.value
        | _ -> false

let performInstruction (registers:Map<string,int>) (instruction:Instruction) =
    if evalCondition registers instruction.cond then
        let currentValue = registers[instruction.reg]
        let newValue =
            match instruction.dir with
                | "inc" -> currentValue + instruction.value
                | "dec" -> currentValue - instruction.value
                | _ -> currentValue
        let modified = registers.Remove instruction.reg
        modified.Add (instruction.reg, newValue)
    else registers

let solveParts instructions =
    let mutable registers = initRegisters instructions
    let mutable maxes:list<int> = []
    for i in instructions do
        registers <- performInstruction registers i
        let m = registers.Values |> Seq.max
        maxes <- m :: maxes    
    maxes.Head, maxes |> List.max

let rx = Regex(@"([a-z]+) (inc|dec) (-?[0-9]+) if ([a-z]+) ([<>=!]+) (-?[0-9]+)")

let parseInstruction line =
    let m = rx.Match(line).Groups
    let cond = {reg=m[4].Value; comp=m[5].Value; value=int m[6].Value}
    {reg=m[1].Value; dir=m[2].Value; value=int m[3].Value; cond=cond}

let solveDay08 isTest: Unit =
    let day = 08
    let puzzleName = "I Heard You Like Registers"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let instructions = readInput inputName true |> List.map (fun line -> parseInstruction line)

    let solution1,solution2 = solveParts instructions
    printfn $"Part One: the largest value in a register is {solution1}"
    printfn $"Part Two: the largest ever value in a register was {solution2}"
