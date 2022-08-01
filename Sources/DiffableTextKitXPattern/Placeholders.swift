//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Placeholders [...]
//*============================================================================*

@usableFromInline enum Placeholders: Equatable {
    @usableFromInline typealias Predicate = (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    
    case none
    case some(Some)
    case many(Many)
    
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Predicate? { switch self {
        case .some(let some): return some[character]
        case .many(let many): return many[character]
        case .none:           return nil }
    }
}

//*============================================================================*
// MARK: * Some [...]
//*============================================================================*

@usableFromInline struct Some: Equatable {
    @usableFromInline typealias Predicate = (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let elements: (Character, Predicate)
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_   elements: (Character, Predicate)) {
        self.elements = elements
    }
    
    @inlinable subscript(character: Character) -> Predicate? {
        elements.0 == character ? elements.1 : nil
    }
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements.0 == rhs.elements.0
    }
}
    
//*============================================================================*
// MARK: * Many [...]
//*============================================================================*

@usableFromInline struct Many: Equatable {
    @usableFromInline typealias Predicate = (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let elements: [Character: Predicate]
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_   elements: [Character: Predicate]) {
        self.elements = elements
    }
    
    @inlinable subscript(character: Character) -> Predicate? {
        elements[character]
    }
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements.keys == rhs.elements.keys
    }
}
