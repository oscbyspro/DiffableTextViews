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

public struct PatternTextPlaceholders: Equatable {
    
    @usableFromInline typealias Predicate = (Character) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let option: Option
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.option = .none
    }
    
    @inlinable public init(_ placeholers: (Character, (Character) -> Bool)) {
        self.option = .some(Some(placeholers))
    }
    
    @inlinable public init(_ placeholers: [Character: (Character) -> Bool]) {
        self.option = .many(Many(placeholers))
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

extension PatternTextPlaceholders {
    
    //*========================================================================*
    // MARK: * Some [...]
    //*========================================================================*
    
    @usableFromInline struct Some: Equatable {
                
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: (Character, Predicate)
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(  _ elements: (Character, Predicate)) {
            self.elements = elements
        }
        
        @inlinable subscript(character: Character) -> Predicate? {
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
                
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: [Character: Predicate]
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(  _ elements: [Character: Predicate]) {
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
