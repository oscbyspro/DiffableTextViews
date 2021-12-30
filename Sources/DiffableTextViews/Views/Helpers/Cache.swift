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
    @usableFromInline var edits: Bool
    
    // MARK: Initializers
    
    @inlinable init() {
        self.field = Field()
        self.edits = false
    }
    
    // MARK: Getters
    
    @inlinable var selection: Selection {
        field.selection
    }
    
    @inlinable var snapshot: Snapshot {
        field.carets.snapshot
    }
}
