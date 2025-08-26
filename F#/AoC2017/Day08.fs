[<AutoOpen>]
module Day08

open AoC.Util
open System.Text.RegularExpressions

type IncDec = 
    | Increase
    | Decrease
    | None

type Comparison =
    | EqualTo
    | NotEqualTo
    | LessThan
    | GreaterThan
    | GreaterThanOrEqualTo
    | LessThanOrEqualTo
    | None

type Condition =
    {
        reg:string
        comp:Comparison
        value:int
    }

type Instruction = 
    {
        reg:string
        dir:IncDec
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
        | EqualTo -> testValue = condition.value
        | NotEqualTo -> testValue <> condition.value
        | LessThan -> testValue < condition.value
        | GreaterThan -> testValue > condition.value
        | LessThanOrEqualTo -> testValue <= condition.value
        | GreaterThanOrEqualTo -> testValue >= condition.value
        | None -> false

let performInstruction (registers:Map<string,int>) (instruction:Instruction) =
    if evalCondition registers instruction.cond then
        let currentValue = registers[instruction.reg]
        let newValue =
            match instruction.dir with
                | Increase -> currentValue + instruction.value
                | Decrease -> currentValue - instruction.value
                | IncDec.None -> currentValue
        let modified = registers.Remove instruction.reg
        modified.Add (instruction.reg, newValue)
    else registers


let solvePartOne instructions =
    let mutable registers = initRegisters instructions
    for i in instructions do
        registers <- performInstruction registers i
    registers.Values
    |> Seq.max


let solvePartTwo instructions =
    let mutable registers = initRegisters instructions
    let mutable maxes:list<int> = []
    for i in instructions do
        registers <- performInstruction registers i
        let m = registers.Values |> Seq.max
        maxes <- m :: maxes
    
    maxes |> List.max

let strToComparison s =
    match s with
        | "==" -> EqualTo
        | "!=" -> NotEqualTo
        | "<"  -> LessThan
        | ">"  -> GreaterThan
        | "<="  -> LessThanOrEqualTo
        | ">="  -> GreaterThanOrEqualTo
        | _     -> None

let rx = Regex(@"([a-z]+) (inc|dec) (-?[0-9]+) if ([a-z]+) ([<>=!]+) (-?[0-9]+)")

let parseInstruction line =
    let m = rx.Match(line).Groups
    let cond = {reg=m[4].Value; comp=strToComparison m[5].Value; value=int m[6].Value}
    let dir:IncDec =
        match m[2].Value with
            | "inc" -> Increase
            | "dec" -> Decrease
            | _     -> IncDec.None
    {reg=m[1].Value; dir=dir; value=int m[3].Value; cond=cond}


let solveDay08 isTest: Unit =
    let day = 08
    let puzzleName = "I Heard You Like Registers"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let instructions = readInput inputName true |> List.map (fun line -> parseInstruction line)

    let solution1 = solvePartOne instructions
    printfn $"Part One: the largest value in a register is {solution1}"
    let solution2 = solvePartTwo instructions
    printfn $"Part Two: the largest ever value in a register was {solution2}"
