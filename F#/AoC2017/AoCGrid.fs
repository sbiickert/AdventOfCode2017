namespace AoC

open System.Collections.Generic
open AoC.Util
open AoC.Geometry

module Grid =

    type GridData = 
        | Glyph of glyph: string
        | Value of value: int64
        | Complex of glyph: string * value:obj

    type GridDataStore =
        | Hash of hash: Dictionary<Coord, GridData>
        | Array of array: GridData[,]

    type Grid =
        {
            data: GridDataStore
            extent: Extent option
            rule: AdjacencyRule
            defaultValue: string
        }

    let mkHGrid defaultValue rule =
        let ds = new Dictionary<Coord, GridData>()
        {data = Hash ds; extent = None; rule = rule; defaultValue = defaultValue}

    let mkAGrid defaultValue rule (size:int) =
        let ds = Array2D.create size size (Glyph defaultValue)
        let ext = mkExtI 0 0 (int64 (size-1)) (int64 (size-1))
        {data = Array ds; extent = Some ext; rule = rule; defaultValue = defaultValue}
    
    module Grid =
        let getValue coord grid = 
            match grid.data with
            | Hash h ->
                if h.ContainsKey coord then
                    h.Item coord
                else
                    Glyph grid.defaultValue
            | Array a ->
                if Extent.contains grid.extent.Value coord then
                    a[int coord.x, int coord.y]
                else
                    Glyph grid.defaultValue

        
        let getString coord grid =
            let gridData = getValue coord grid
            match gridData with
            | Glyph g -> g
            | Value i -> i.ToString()
            | Complex (glyph, _) -> glyph

        let getInteger coord grid = 
            let gridData = getValue coord grid
            match gridData with
            | Value i -> i
            | Glyph g -> int64 g
            | _ -> 0 

        let setValue coord value grid = 
            match grid.data with
            | Hash h ->
                if h.ContainsKey coord then
                    h.Remove coord |> ignore
                h.Add (coord,value)
                
                let newExtent = 
                    if grid.extent.IsNone then
                        mkExtent [coord]
                    else
                        Extent.expandToFit grid.extent.Value [coord]
                {grid with extent = Some newExtent}            
            | Array a ->
                if Extent.contains grid.extent.Value coord then
                    a[int coord.x, int coord.y] <- value
                    grid
                else
                    grid


        // let batchUpdate (data:Map<Coord,GridData option>) grid =
        //     data
        //     |> Map.map (fun coord value ->
        //         grid.data.Remove coord |> ignore
        //         if data[coord].IsSome then
        //             grid.data.Add (coord,value.Value)
        //         )
        //     |> ignore

        let copy grid =
            match grid.data with
            | Hash h -> 
                let clonedData = new Dictionary<Coord, GridData>()
                for coord in h.Keys do
                    clonedData.Add(coord,h.Item coord)
                {grid with data=Hash clonedData; extent=grid.extent; rule=grid.rule; defaultValue=grid.defaultValue}
            | Array a -> 
                {grid with data=Array (Array2D.copy a)}

        let load (input: string list) defaultValue rule (fixedSize:option<int>) =
            let mutable grid = 
                if fixedSize.IsNone then
                    mkHGrid defaultValue rule
                else
                    mkAGrid defaultValue rule fixedSize.Value

            let yseq = seq { for y in [0 .. input.Length-1] -> (y, input[y]) }
            for (y, line) in yseq do
                let chars = Seq.toList line |> List.map (fun c -> c.ToString())
                let xseq = seq { for x in [0 .. chars.Length-1] -> (x, chars[x]) }
                for (x, c) in xseq do
                    if fixedSize.IsSome || c <> grid.defaultValue then
                        grid <- setValue {x = x; y = y} (Glyph c) grid
            grid
        
        let clear coord resetExtent grid =
            match grid.data with
            | Hash h ->
                let removeSuccessful = h.Remove coord
                let newExtentOpt = 
                    if resetExtent && removeSuccessful then
                        let coords = List.ofSeq h.Keys
                        Some(mkExtent coords)
                    else
                        grid.extent
                {grid with extent = newExtentOpt}
            | Array a ->
                if Extent.contains grid.extent.Value coord then
                    a[int coord.x, int coord.y] <- Glyph grid.defaultValue
                grid
        
        let coords (withValue: string option) grid =
            if withValue.IsNone then
                match grid.data with
                | Hash h -> List.ofSeq h.Keys
                | Array a -> Extent.allCoordsIn grid.extent.Value
            else
                let value = withValue.Value
                let seq:Coord seq =
                    match grid.data with
                    | Hash h -> h.Keys
                    | Array a -> Extent.allCoordsSequence grid.extent.Value
                seq
                |> Seq.filter (fun coord -> getString coord grid = value)
                |> List.ofSeq
        
        let histogram includeUnset grid: Map<string,int> =
            if grid.extent.IsNone then Map.empty
            else
                let ext = grid.extent.Value
                let coordsToSum =
                    if includeUnset then
                        Extent.allCoordsIn ext
                    else
                        coords None grid

                coordsToSum
                |> List.map (fun coord -> getString coord grid)
                |> AoC.Util.frequencyMap

        let neighbors coord grid =
            Coord.adjacentCoords coord grid.rule

        let sprint (markers:Map<Coord,string> option) (grid:Grid) =
            if grid.extent.IsNone then ""
            else
                let ext = grid.extent.Value
                cartesian [ext.min.y .. ext.max.y] [ext.min.x .. ext.max.x+1L] // +1 to extend outside ext
                |> List.map (fun (y, x) -> mkCoord x y)
                |> List.map (fun coord -> 
                    if Extent.contains ext coord then
                        if markers.IsSome && markers.Value.ContainsKey coord then
                            markers.Value.Item coord
                        else
                            getString coord grid
                    else
                        "\n")
                |> List.fold (+) ""

        let print (markers:Map<Coord,string> option) (grid:Grid) =
            let str = sprint markers grid
            printfn $"{str}"

