#load "AoCUtil.fs"
#load "AoCGeometry.fs"
#load "AoCGrid.fs"

open AoC.Util
open AoC.Geometry
open AoC.Grid

type GameObj =
    {
        name: string
        hp: int
    }

let testHGrid () =
    let mutable grid = mkHGrid "." AdjacencyRule.Rook
    assertEqual "." grid.defaultValue
    assertEqual AdjacencyRule.Rook grid.rule
    assertTrue grid.extent.IsNone

    let c = [| mkCoord 1 1;mkCoord 2 2;mkCoord 3 3;mkCoord 4 4;mkCoord 1 4;mkCoord 2 4;mkCoord 3 4 |]
    grid <- Grid.setValue c[0] (Glyph "A") grid
    grid <- Grid.setValue c[1] (Glyph "B") grid
    grid <- Grid.setValue c[3] (Glyph "D") grid

    assertEqual "A" (Grid.getString c[0] grid)
    assertEqual "B" (Grid.getString c[1] grid)
    assertEqual grid.defaultValue (Grid.getString c[2] grid)
    assertEqual "D" (Grid.getString c[3] grid)
    
    assertTrue grid.extent.IsSome
    assertEqual c[0] grid.extent.Value.min
    assertEqual c[3] grid.extent.Value.max

    grid <- Grid.setValue c[4] (Complex ("E", {name = "Elf"; hp = 100})) grid
    grid <- Grid.setValue c[5] (Complex ("G", {name = "Goblin"; hp = 95})) grid
    grid <- Grid.setValue c[6] (Complex ("S", {name = "Santa"; hp = 1000})) grid

    assertEqual "E" (Grid.getString c[4] grid)
    assertEqual "G" (Grid.getString c[5] grid)
    let santaGridData = Grid.getValue c[6] grid
    match santaGridData with
    | Complex (glyph, santaObj:obj) -> 
        let santa = santaObj :?> GameObj
        assertEqual 1000 santa.hp
    | _ -> ()

    let allCoords = Grid.coords None grid
    assertEqual 6 allCoords.Length
    let coordsWithB = Grid.coords (Some "B") grid
    assertEqual c[1] coordsWithB.Head

    // Histogram
    grid <- Grid.setValue c[2] (Glyph "B") grid
    let hist = Grid.histogram false grid
    assertEqual 1 (hist.Item "A")
    assertEqual 2 (hist.Item "B")
    assertFalse (hist.ContainsKey grid.defaultValue)
    let histWithDefault = Grid.histogram true grid
    assertEqual 9 (histWithDefault.Item grid.defaultValue)

    //printGrid grid None
    let gridStr = Grid.sprint None grid
    assertEqual "A...\n.B..\n..B.\nEGSD\n" gridStr

    let markers = Map [{x = 4; y = 1}, "*"]
    //printGrid grid (Some markers)
    let gridStrM = Grid.sprint (Some markers) grid
    assertEqual "A..*\n.B..\n..B.\nEGSD\n" gridStrM

    // Clearing
    grid <- Grid.clear c[2] false grid
    assertEqual grid.defaultValue (Grid.getString c[2] grid)
    let originalExt = grid.extent.Value
    let c100 = {x = 100; y = 100}
    grid <- Grid.setValue c100 (Glyph "X") grid
    assertEqual grid.extent.Value.max c100
    grid <- Grid.clear c100 true grid
    assertEqual originalExt grid.extent.Value

let testAGrid () =
    let mutable grid = mkAGrid "." AdjacencyRule.Rook 5
    assertEqual "." grid.defaultValue
    assertEqual AdjacencyRule.Rook grid.rule
    assertFalse grid.extent.IsNone
    assertEqual grid.extent.Value (mkExtI 0 0 4 4)

    let c = [| mkCoord 1 1;mkCoord 2 2;mkCoord 3 3;mkCoord 4 4;mkCoord 1 4;mkCoord 2 4;mkCoord 3 4 |]
    grid <- Grid.setValue c[0] (Glyph "A") grid
    grid <- Grid.setValue c[1] (Glyph "B") grid
    grid <- Grid.setValue c[3] (Glyph "D") grid

    assertEqual "A" (Grid.getString c[0] grid)
    assertEqual "B" (Grid.getString c[1] grid)
    assertEqual grid.defaultValue (Grid.getString c[2] grid)
    assertEqual "D" (Grid.getString c[3] grid)
    
    assertTrue grid.extent.IsSome
    assertEqual Coord.origin grid.extent.Value.min
    assertEqual c[3] grid.extent.Value.max

    grid <- Grid.setValue c[4] (Complex ("E", {name = "Elf"; hp = 100})) grid
    grid <- Grid.setValue c[5] (Complex ("G", {name = "Goblin"; hp = 95})) grid
    grid <- Grid.setValue c[6] (Complex ("S", {name = "Santa"; hp = 1000})) grid

    assertEqual "E" (Grid.getString c[4] grid)
    assertEqual "G" (Grid.getString c[5] grid)
    let santaGridData = Grid.getValue c[6] grid
    match santaGridData with
    | Complex (glyph, santaObj:obj) -> 
        let santa = santaObj :?> GameObj
        assertEqual 1000 santa.hp
    | _ -> ()

    let allCoords = Grid.coords None grid
    assertEqual 25 allCoords.Length
    let coordsWithB = Grid.coords (Some "B") grid
    assertEqual c[1] coordsWithB.Head

    // Histogram
    grid <- Grid.setValue c[2] (Glyph "B") grid
    let hist = Grid.histogram false grid
    assertEqual 1 (hist.Item "A")
    assertEqual 2 (hist.Item "B")
    assertTrue (hist.ContainsKey grid.defaultValue)
    let histWithDefault = Grid.histogram true grid
    assertEqual 18 (histWithDefault.Item grid.defaultValue)

    // Grid.print None grid

    let gridStr = Grid.sprint None grid
    assertEqual ".....\n.A...\n..B..\n...B.\n.EGSD\n" gridStr

    let markers = Map [{x = 4; y = 1}, "*"]
    //printGrid grid (Some markers)
    let gridStrM = Grid.sprint (Some markers) grid
    assertEqual ".....\n.A..*\n..B..\n...B.\n.EGSD\n" gridStrM

    // Clearing
    grid <- Grid.clear c[2] false grid
    assertEqual grid.defaultValue (Grid.getString c[2] grid)
    let originalExt = grid.extent.Value
    
    // Doing anything outside the extent has no effect
    let c100 = {x = 100; y = 100}
    grid <- Grid.setValue c100 (Glyph "X") grid
    assertEqual originalExt grid.extent.Value
    grid <- Grid.clear c100 true grid
    assertEqual originalExt grid.extent.Value


testHGrid()

testAGrid()

let testLoad () =
    let input = ["abcd";"e.gh";"ijkl"]

    let gridH = Grid.load input "." AdjacencyRule.Rook None
    let gridHStr = Grid.sprint None gridH
    assertEqual "abcd\ne.gh\nijkl\n" gridHStr
    assertEqual (Grid.getString Coord.origin gridH) "a"
    assertEqual 11 (Grid.coords None gridH).Length // The "." would not be set during load
       
    let gridA = Grid.load input "." AdjacencyRule.Rook (Some 4)
    let gridAStr = Grid.sprint None gridA
    assertEqual "abcd\ne.gh\nijkl\n....\n" gridAStr
    assertEqual (Grid.getString Coord.origin gridA) "a"
    assertEqual 16 (Grid.coords None gridA).Length // The "."s are set during load


testLoad()

printfn $"**** All tests passed. ****"
