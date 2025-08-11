// #load "AoCUtil.fs"
// #load "AoCGeometry.fs"
// #load "AoCGrid.fs"

// #load "Day06.fs"
// #time
// solveDay06 false |> ignore
// #time

let l = [1;2;3]
l |> List.reduce (fun acc elem -> acc + elem)