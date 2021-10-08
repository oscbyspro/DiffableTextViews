//
//  CollectionStrideInstruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionStrideInstruction<Collection: Swift.Collection> {
    public typealias Bound = Sequences.Bound<Collection.Index>
    public typealias Steps = Sequences.CollectionStrideSteps<Collection>
    public typealias Stride = Sequences.CollectionStrideInstruction<Collection>
    public typealias Loop = Sequences.CollectionStride<Collection>
    
    // MARK: Properties
    
    @usableFromInline let make: (Collection) -> Loop
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Collection) -> Loop) {
        self.make = make
    }
}

public extension CollectionStrideInstruction {
    // MARK: Interval
    
    @inlinable static func interval(from min: Bound? = nil, to max: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionStride(collection, min: min, max: max, steps: steps)
        }
    }
    
    // MARK: Stride
    
    @inlinable static func stride(from start: Bound? = nil, to limit: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionStride(collection, start: start, limit: limit, steps: steps)
        }
    }
}

// MARK: -

public extension Collection {
    // MARK: Loop
    
    @inlinable func loop(_ instruction: CollectionStrideInstruction<Self>) -> CollectionStride<Self> {
        instruction.make(self)
    }
    
    // MARK: Indices
    
    @inlinable func indices(_ instruction: CollectionStrideInstruction<Self>) -> AnyIterator<Index> {
        instruction.make(self).indices()
    }
    
    // MARK: Elements
    
    @inlinable func elements(_ instruction: CollectionStrideInstruction<Self>) -> AnyIterator<Element> {
        instruction.make(self).elements()
    }
}
