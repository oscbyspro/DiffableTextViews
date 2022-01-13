//
//  Offset.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

//*============================================================================*
// MARK: * Offset
//*============================================================================*

@usableFromInline struct Offset<Scheme: DiffableTextViews.Scheme>: Equatable, Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let units: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(at units: Int = 0) {
        self.units = units
    }
    
    @inlinable init<S: StringProtocol>(at position: String.Index, in characters: S) {
        self.units = Scheme.size(of: characters[...position])
    }
    
    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self {
        Self()
    }
    
    @inlinable static func size(of character: Character) -> Self {
        Self(at: Scheme.size(of: character))
    }
        
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Self {
        Self(at: Scheme.size(of: characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Stride
    //=------------------------------------------------------------------------=

    @inlinable func after(_ character: Character?) -> Self {
        guard let character = character else { return self }
        return .init(at: units + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character?) -> Self {
        guard let character = character else { return self }
        return .init(at: units - Scheme.size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.units < rhs.units
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Arithmetics
    //=------------------------------------------------------------------------=

    @inlinable static func + (lhs: Self, rhs: Self) -> Self {
        .init(at: lhs.units + rhs.units)
    }
    
    @inlinable static func - (lhs: Self, rhs: Self) -> Self {
        .init(at: lhs.units - rhs.units)
    }
}
