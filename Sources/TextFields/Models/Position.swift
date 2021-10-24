//
//  Position.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Position

@usableFromInline struct Position<Layout: TextFields.Layout>: Comparable {

    // MARK: Properties
    
    @usableFromInline let offset: Int
    
    // MARK: Initializers
    
    @inlinable init(at offset: Int) {
        self.offset = offset
    }
    
    // MARK: Initializers: Static
    
    @inlinable static var origin: Self {
        .init(at: .zero)
    }
    
    @inlinable static func max(in characters: String) -> Self {
        .init(at: Layout.size(of: characters))
    }
    
    // MARK: Transformations
    
    @inlinable func after(_ character: Character?) -> Self {
        guard let character = character else {
            return self
        }
        
        return .init(at: offset + Layout.size(of: character))
    }
    
    @inlinable func before(_ character: Character?) -> Self {
        guard let character = character else {
            return self
        }

        return .init(at: offset - Layout.size(of: character))
    }
    
    // MARK: Comparisons
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset < rhs.offset
    }
}
