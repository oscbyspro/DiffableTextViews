//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Index [...]
//*============================================================================*

/// A character encoded index and offset.
public struct Index: Comparable, CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let character: String.Index
    @usableFromInline let attribute: Int
    
    //=------------------------------------------------------------------------=
    
    /// Creates an instance describing a character's position.
    ///
    /// - Parameters:
    ///   - character: The character encoded index.
    ///   - attribute: The character encoded offset.
    ///
    @inlinable @inline(__always) init(_ character: String.Index, as attribute: Int) {
        self.character = character
        self.attribute = attribute
    }
    
    public var description: String {
        String(describing: attribute)
    }
    
    @inlinable @inline(__always) public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.attribute == rhs.attribute
    }
    
    @inlinable @inline(__always) public static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.attribute <  rhs.attribute
    }
}
