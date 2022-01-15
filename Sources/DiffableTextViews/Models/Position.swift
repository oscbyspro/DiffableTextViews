//
//  Position.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

#warning("Rename.")

//*============================================================================*
// MARK: * Position
//*============================================================================*

@usableFromInline struct Position<Scheme: DiffableTextViews.Scheme>: Equatable, Comparable, ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let offset: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ offset: Int) {
        self.offset = offset
    }
    
    @inlinable init(integerLiteral value: Int) {
        self.offset = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var start: Self {
        Self(0)
    }
    
    @inlinable static func end(of character: Character) -> Self {
        Self(Scheme.size(of: character))
    }
        
    @inlinable static func end<S: StringProtocol>(of characters: S) -> Self {
        Self(Scheme.size(of: characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func after(_ character: Character) -> Self {
        Self(offset + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character) -> Self {
        Self(offset - Scheme.size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset <  rhs.offset
    }
}
