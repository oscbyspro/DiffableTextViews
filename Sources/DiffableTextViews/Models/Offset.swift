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
    
    @inlinable init(at units: Int) {
        self.units = units
    }
    
    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self {
        .init(at: .zero)
    }
    
    @inlinable static func max(in characters: String) -> Self {
        .init(at: Scheme.size(of: characters))
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
