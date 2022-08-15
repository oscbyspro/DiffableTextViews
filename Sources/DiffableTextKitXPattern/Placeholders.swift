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
    
    @inlinable init(_ some: Some.Elements) {
        self.option = .some(Some(some))
    }
    
    @inlinable init(_ many: Many.Elements) {
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
        
        @usableFromInline typealias Elements = (Character, Predicate)
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: Elements
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(  _ elements: Elements) {
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
        
        @usableFromInline typealias Elements = [Character: Predicate]
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: Elements
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(  _ elements: Elements) {
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
