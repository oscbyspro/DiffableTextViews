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
    
    @inlinable static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self>
    
    @inlinable static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self>
    
    @inlinable static func index(at distance: Offset<Self>,
    from start: Index, in snapshot: Snapshot) -> Index
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self> {
        distance(from: start.character, to: end.character, in: snapshot.characters)
    }
    
    @inlinable public static func index(at distance: Offset<Self>,
    from start: Index, in snapshot: Snapshot) -> Index {
        if  distance > 0 { return positive(distance, from: start, in: snapshot) }
        if  distance < 0 { return negative(distance, from: start, in: snapshot) }
        return start
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers x Index
    //=------------------------------------------------------------------------=
    
    @inlinable static func positive(_ distance: Offset<Self>,
    from start: Index, in snapshot: Snapshot) -> Index {
        var index = start; var distance = distance
        //=--------------------------------------=
        // Forwards
        //=--------------------------------------=
        forwards: while true {
            let after = snapshot.index(after: index)
            distance -= self.distance(from: index, to: after, in: snapshot)
            //=----------------------------------=
            // None
            //=----------------------------------=
            if distance > 0 {
                index = after; continue forwards
            }
            //=----------------------------------=
            // Some
            //=----------------------------------=
            return distance == 0 ? after : index
        }
    }
    
    @inlinable static func negative(_ distance: Offset<Self>,
    from start: Index, in snapshot: Snapshot) -> Index {
        var index = start; var distance = distance
        //=--------------------------------------=
        // Backwards
        //=--------------------------------------=
        backwards: while true {
            let after = index; snapshot.formIndex(before: &index)
            distance += self.distance(from: index, to: after, in: snapshot)
            //=----------------------------------=
            // Some
            //=----------------------------------=
            if distance >= 0 { return index }
        }
    }
}

//*============================================================================*
// MARK: * Encoding x Character
//*============================================================================*

extension Character: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.distance(from: start, to: end))
    }
    
    @inlinable public static func distance(from start: Index,
    to end: Index, in snapshot: Snapshot) -> Offset<Self> {
        Offset(end.attribute - start.attribute)
    }
    
    @inlinable public static func index(at distance: Offset<Self>,
    from start: Index, in snapshot: Snapshot) -> Index {
        snapshot.index(start, offsetBy: Int(distance))
    }
}

//*============================================================================*
// MARK: * Encoding x Unicode.Scalar
//*============================================================================*

extension Unicode.Scalar: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.unicodeScalars.distance(from: start, to: end))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF8
//*============================================================================*

extension UTF8: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf8.distance(from: start, to: end))
    }
}

//*============================================================================*
// MARK: * Encoding x UTF16
//*============================================================================*

extension UTF16: Encoding {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func distance(from start: String.Index,
    to end: String.Index, in characters: some StringProtocol) -> Offset<Self> {
        Offset(characters.utf16.distance(from: start, to: end))
    }
}
