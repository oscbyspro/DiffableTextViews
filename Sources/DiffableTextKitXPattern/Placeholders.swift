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

public struct PatternTextPlaceholders: Equatable, ExpressibleByDictionaryLiteral {
    
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
    
    @inlinable public init(_ character: Character, where predicate: @escaping (Character) -> Bool) {
        self.option = .some(Some(base: (character, predicate)))
    }
    
    @inlinable public init(_ some: (Character, (Character) -> Bool)) {
        self.option = .some(Some(base: some))
    }
    
    @inlinable public init(_ many: [Character: (Character) -> Bool]) {
        self.option = .many(Many(base: many))
    }
    
    @inlinable public init(dictionaryLiteral elements: (Character, (Character) -> Bool)...) {
        switch elements.count {
        case 1:    self.init(elements[0])
        case 2...: self.init(Dictionary(elements, uniquingKeysWith: { $1 }))
        default:   self.init() }
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
    
    //*========================================================================*
    // MARK: * Some [...]
    //*========================================================================*
    
    @usableFromInline struct Some: Equatable {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: (Character, Predicate)
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(base: (Character, Predicate)) {
            self.base = base
        }
        
        @inlinable subscript(character: Character) -> Predicate? {
            base.0 == character ? base.1 : nil
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.base.0 == rhs.base.0
        }
    }
    
    //*========================================================================*
    // MARK: * Many [...]
    //*========================================================================*

    @usableFromInline struct Many: Equatable {
                
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: [Character: Predicate]
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(base: [Character: Predicate]) {
            self.base = base
        }
        
        @inlinable subscript(character: Character) -> Predicate? {
            base[character]
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.base.keys == rhs.base.keys
        }
    }
}
