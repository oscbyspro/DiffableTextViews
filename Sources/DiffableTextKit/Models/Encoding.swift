//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Encoding
//*============================================================================*

public protocol Encoding {
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func distance(
    from start: Index, to end: Index,
    in snapshot: Snapshot) -> Offset<Self>
    
    @inlinable static func index(
    at distance: Offset<Self>, from start: Index,
    in snapshot: Snapshot) -> Index
}

//*============================================================================*
// MARK: * Encoding x Character
//*============================================================================*

extension Character: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(
    from start: Index,to end: Index,
    in snapshot: Snapshot) -> Offset<Self> {
        .character(end.attribute - start.attribute)
    }
    
    @inlinable public static func index(
    at distance: Offset<Self>, from start: Index,
    in snapshot: Snapshot) -> Index {
        snapshot.index(start, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(
    from start: Index,  to end: Index,
    in snapshot: Snapshot) -> Offset<Self> {
        .utf16(snapshot.characters.utf16.distance(
        from: start.character, to: end.character))
    }
    
    @inlinable public static func index(
    at distance: Offset<Self>, from start: Index,
    in snapshot: Snapshot) -> Index {
        var index = start; var distance = distance
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        if distance > 0 {
            while true {
                distance -= .utf16(snapshot.characters[index.character].utf16.count)
                //=------------------------------=
                // None
                //=------------------------------=
                if distance > 0 {
                    snapshot.formIndex(after: &index)
                    continue
                }
                //=------------------------------=
                // Some
                //=------------------------------=
                if distance == 0 {
                    snapshot.formIndex(after: &index)
                }

                return index
            }
        }
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        else if distance < 0 {
            while true {
                snapshot.formIndex(before: &index)
                distance += .utf16(snapshot.characters[index.character].utf16.count)
                //=------------------------------=
                // Some
                //=------------------------------=
                if distance >= 0 { return  index }
            }
        //=--------------------------------------=
        // Return Start Because Distance Is Zero
        //=--------------------------------------=
        } else { return start }
    }
}
