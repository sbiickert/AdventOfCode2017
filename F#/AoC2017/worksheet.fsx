// #load "AoCUtil.fs"
// // #load "AoCGeometry.fs"
// // #load "AoCGrid.fs"

// #load "Day01.fs"
// #time
// solveDay01 false |> ignore
// #time

let a:string[,] = Array2D.create 5 6 "boo"
let b = Array2D.copy a

b[3,4] <- "sam"
a
b