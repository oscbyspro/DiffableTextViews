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

@usableFromInline struct Placeholders: Equatable {
    
    @usableFromInline typealias Predicate = (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let option: Option
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.option = .none
    }
    
    @inlinable init(_ some: (Character, Predicate)) {
        self.option = .some(Some(some))
    }
    
    @inlinable init(_ many: [Character: Predicate]) {
        self.option = .many(Many(many))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Predicate? {
        switch option {
        case .some(let some): return some[character]
        case .many(let many): return many[character]
        case .none:           return nil }
    }
    
    //*========================================================================*
    // MARK: * Option [...]
    //*========================================================================*
    
    @usableFromInline enum Option: Equatable {
        case none
        case some(Some)
        case many(Many)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Option(s)
//=----------------------------------------------------------------------------=

extension Placeholders {
    
    //*========================================================================*
    // MARK: * Some [...]
    //*========================================================================*
    
    @usableFromInline struct Some: Equatable {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: (character: Character, predicate: Predicate)
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ elements: (Character, Predicate)) {
            self.elements = elements
        }
        
        @inlinable subscript(character: Character) -> Predicate? {
            elements.character == character ? elements.predicate : nil
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.elements.character == rhs.elements.character
        }
    }
    
    //*========================================================================*
    // MARK: * Many [...]
    //*========================================================================*

    @usableFromInline struct Many: Equatable {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: [Character: Predicate]
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ elements: [Character: Predicate]) {
            self.elements = elements
        }
        
        @inlinable subscript(character: Character) -> Predicate? {
            elements[character]
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.elements.keys == rhs.elements.keys
        }
    }
}
