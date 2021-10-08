//
//  CollectionLoopInstruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

#warning("Maybe name: CollectionStrideBlueprint")
public struct CollectionLoopInstruction<Collection: Swift.Collection> {
    public typealias Bound = Loops.Bound<Collection.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Collection>
    public typealias Stride = Loops.CollectionLoopStride<Collection>
    public typealias Loop = Loops.CollectionLoop<Collection>
    
    // MARK: Properties
    
    @usableFromInline let make: (Collection) -> Loop
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Collection) -> Loop) {
        self.make = make
    }
}

public extension CollectionLoopInstruction {
    // MARK: Interval
    
    @inlinable static func interval(from min: Bound? = nil, to max: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionLoop(collection, min: min, max: max, steps: steps)
        }
    }
    
    // MARK: Stride
    
    @inlinable static func stride(from start: Bound? = nil, to limit: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionLoop(collection, start: start, limit: limit, steps: steps)
        }
    }
}

// MARK: -

public extension Collection {
    // MARK: Loop
    
    @inlinable func loop(_ instruction: CollectionLoopInstruction<Self>) -> CollectionLoop<Self> {
        instruction.make(self)
    }
    
    // MARK: Indices
    
    @inlinable func indices(_ instruction: CollectionLoopInstruction<Self>) -> AnyIterator<Index> {
        instruction.make(self).indices()
    }
    
    // MARK: Elements
    
    @inlinable func elements(_ instruction: CollectionLoopInstruction<Self>) -> AnyIterator<Element> {
        instruction.make(self).elements()
    }
}
