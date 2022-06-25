//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Placeholders
//*============================================================================*

/// - It does not compare predicates on equals.
@usableFromInline enum Placeholders: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case one ((Character, (Character) -> Bool))
    case many([Character: (Character) -> Bool])
    case none
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
        switch self {
        case .one (let element ): return element.0 == character ? element.1 : nil
        case .many(let elements): return elements[character]
        case .none:               return nil
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.one (let a), .one (let b)): return a.0    == b.0
        case (.many(let a), .many(let b)): return a.keys == b.keys
        case (.none,        .none       ): return true
        default:                           return false
        }
    }
}
