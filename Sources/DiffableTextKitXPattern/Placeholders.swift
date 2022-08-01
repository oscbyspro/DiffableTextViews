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

@usableFromInline enum Placeholders: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case none
    case some(Some)
    case many(Many)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .none
    }
    
    @inlinable init(_ some: (Character, (Character) -> Bool)) {
        self = .some(Some(some))
    }
    
    @inlinable init(_ many: [Character: (Character) -> Bool]) {
        self = .many(Many(many))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
        switch self {
        case .some(let some): return some[character]
        case .many(let many): return many[character]
        case .none:           return nil }
    }
}

//*============================================================================*
// MARK: * Placeholders x Some [...]
//*============================================================================*

@usableFromInline struct Some: Equatable {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let elements: (Character, (Character) -> Bool)
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_   elements: (Character, (Character) -> Bool)) {
        self.elements = elements
    }
    
    @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
        self.elements.0 == character ? self.elements.1 : nil
    }
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements.0 == rhs.elements.0
    }
}
    
//*============================================================================*
// MARK: * Placeholders x Many [...]
//*============================================================================*

@usableFromInline struct Many: Equatable {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let elements: [Character: (Character) -> Bool]
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_   elements: [Character: (Character) -> Bool]) {
        self.elements = elements
    }
    
    @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
        self.elements[character]
    }
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements.keys == rhs.elements.keys
    }
}
