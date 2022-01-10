//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

//*============================================================================*
// MARK: * Digits
//*============================================================================*

/// A representation of system digits.
///
/// - Digits.count (stored) is accessed in O(1) time.
///
@usableFromInline struct Digits: Text {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var characters: String = ""
    @usableFromInline private(set) var count: Int = 0
    
    //
    // MARK: Properties - Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isEmpty: Bool {
        characters.isEmpty
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func prefixZerosCount() -> Int {
        characters.count(while: Self.isZero)
    }
    
    @inlinable func suffixZerosCount() -> Int {
        characters.reversed().count(while: Self.isZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ character: Character) {
        characters.append(character)
        count += 1
    }
    
    @inlinable mutating func removeRedundantZerosPrefix() {
        characters.removeSubrange(..<characters.dropLast().prefix(while: Self.isZero).endIndex)
    }
    
    @inlinable mutating func replaceWithZeroIfItIsEmpty() {
        guard isEmpty else { return }; characters.append(Self.zero)
    }
    
    //=----------------------------------------------------------------------------=
    // MARK: Predicates - Static
    //=----------------------------------------------------------------------------=
    
    @inlinable static func isZero(_ character: Character) -> Bool {
        character == Self.zero
    }

    //=----------------------------------------------------------------------------=
    // MARK: Characters - Static
    //=----------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Character = "0"
    @usableFromInline static let decimals = Set<Character>("0123456789")
}