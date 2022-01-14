//
//  Offset.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

//*============================================================================*
// MARK: * Offset
//*============================================================================*

@usableFromInline struct Offset<Scheme: DiffableTextViews.Scheme>: Equatable, Comparable, ExpressibleByIntegerLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let units: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ units: Int = 0) {
        self.units = units
    }
    
    @inlinable init(integerLiteral value: Int) {
        self.units = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self {
        Self()
    }
    
    @inlinable static func size(of character: Character) -> Self {
        Self(Scheme.size(of: character))
    }
        
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Self {
        Self(Scheme.size(of: characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func after(_ character: Character) -> Self {
        Self(units + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character) -> Self {
        Self(units - Scheme.size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.units == rhs.units
    }
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.units <  rhs.units
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Arithmetics
    //=------------------------------------------------------------------------=

    @inlinable static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.units + rhs.units)
    }
    
    @inlinable static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.units - rhs.units)
    }
}
