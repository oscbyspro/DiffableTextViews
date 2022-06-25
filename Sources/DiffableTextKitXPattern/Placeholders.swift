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
@usableFromInline struct Placeholders: Equatable {
    @usableFromInline typealias Predicate = (Character) -> Bool
    @usableFromInline typealias Element   = (Character, Predicate)
    @usableFromInline typealias Elements  = [Character: Predicate]
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init() {
        self.storage = .none
    }
    
    @inlinable @inline(__always) init(_ element:  Element) {
        self.storage = .some(Some(element))
    }
    
    @inlinable @inline(__always) init(_ elements: Elements) {
        self.storage = .many(Many(elements))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Predicate? {
        switch self.storage {
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
    // MARK: * Some
    //*========================================================================*
    
    @usableFromInline struct Some: Equatable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let element: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) init(_ element: Element) {
            self.element = element
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) subscript(character: Character) -> Predicate? {
            self.element.0 == character ? element.1 : nil
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.element.0 == rhs.element.0
        }
    }
    
    //*========================================================================*
    // MARK: * Many
    //*========================================================================*
    
    @usableFromInline struct Many: Equatable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let elements: [Character: Predicate]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) init(_ elements: Elements) {
            self.elements = elements
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) subscript(character: Character) -> Predicate? {
            self.elements[character]
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.elements.keys == rhs.elements.keys
        }
    }
}
