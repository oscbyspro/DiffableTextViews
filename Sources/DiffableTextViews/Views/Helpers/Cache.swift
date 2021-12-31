//
//  Cache.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-06.
//

// MARK: - Cache

@usableFromInline final class Cache<Scheme: DiffableTextViews.Scheme, Value: Equatable> {
    @usableFromInline typealias Selection = DiffableTextViews.Selection<Scheme>
    @usableFromInline typealias Field = DiffableTextViews.Field<Scheme>
    
    // MARK: Properties
    
    @usableFromInline var value: Value!
    @usableFromInline var field: Field
    @usableFromInline var  mode:  Mode
    
    // MARK: Initializers
    
    @inlinable init() {
        self.field = Field()
        self.mode = .showcase
    }
    
    // MARK: Getters
    
    @inlinable var selection: Selection {
        field.selection
    }
    
    @inlinable var snapshot: Snapshot {
        field.carets.snapshot
    }
}
