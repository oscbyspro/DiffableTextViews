//
//  Offset.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Offset

@usableFromInline struct Offset<Scheme: DiffableTextViews.Scheme>: Equatable, Comparable {
    
    // MARK: Properties

    @usableFromInline let distance: Int
    
    // MARK: Initializers
    
    @inlinable init(at distance: Int) {
        self.distance = distance
    }
    
    // MARK: Initializers: Static
    
    @inlinable static var zero: Self {
        .init(at: .zero)
    }
    
    @inlinable static func max(in characters: String) -> Self {
        .init(at: Scheme.size(of: characters))
    }
    
    // MARK: Stride
    
    @inlinable func after(_ character: Character?) -> Self {
        guard let character = character else {
            return self
        }
        
        return .init(at: distance + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character?) -> Self {
        guard let character = character else {
            return self
        }

        return .init(at: distance - Scheme.size(of: character))
    }
    
    // MARK: Comparisons
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.distance < rhs.distance
    }
    
    // MARK: Arithmetics
    
    @inlinable static func + (lhs: Self, rhs: Self) -> Self {
        .init(at: lhs.distance + rhs.distance)
    }
    
    @inlinable static func - (lhs: Self, rhs: Self) -> Self {
        .init(at: lhs.distance - rhs.distance)
    }
}
