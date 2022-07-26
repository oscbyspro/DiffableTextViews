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
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.storage = .none
    }
    
    @inlinable init(_ elements: (Character, (Character) -> Bool)) {
        self.storage = .some(Some(elements))
    }
    
    @inlinable init(_ elements: [Character: (Character) -> Bool]) {
        self.storage = .many(Many(elements))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
        switch storage {
        case .some(let some): return some[character]
        case .many(let many): return many[character]
        case .none:           return nil
        }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline enum Storage: Equatable {
        case none
        case some(Some)
        case many(Many)
    }
    
    //*========================================================================*
    // MARK: * Some [...]
    //*========================================================================*
    
    @usableFromInline struct Some: Equatable {
        
        @usableFromInline let elements: (Character, (Character) -> Bool)
        
        @inlinable init(_ elements: (Character, (Character) -> Bool)) {
            self.elements = elements
        }
        
        @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
            elements.0 == character ? elements.1 : nil
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.elements.0 == rhs.elements.0
        }
    }
    
    //*========================================================================*
    // MARK: * Many [...]
    //*========================================================================*
    
    @usableFromInline struct Many: Equatable {
        
        @usableFromInline let elements: [Character: (Character) -> Bool]
        
        @inlinable init(_ elements: [Character: (Character) -> Bool]) {
            self.elements = elements
        }
        
        @inlinable subscript(character: Character) -> ((Character) -> Bool)? {
            elements[character]
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.elements.keys == rhs.elements.keys
        }
    }
}
