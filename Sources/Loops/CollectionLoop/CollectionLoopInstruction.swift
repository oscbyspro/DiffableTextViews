//
//  CollectionLoopInstruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionLoopInstruction<Base: Collection> {
    public typealias Bound = Loops.Bound<Base.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Base>
    public typealias Stride = Loops.CollectionLoopStride<Base>
    public typealias Loop = Loops.CollectionLoop<Base>
    
    // MARK: Properties
    
    @usableFromInline let make: (Base) -> Loop
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Base) -> Loop) {
        self.make = make
    }
}

public extension CollectionLoopInstruction {
    // MARK: Stride
    
    @inlinable static func stride(from start: Bound? = nil, to limit: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionLoop(through: collection, from: start, towards: limit, steps: steps)
        }
    }
    
    // MARK: Interval
    
    @inlinable static func interval(from min: Bound? = nil, to max: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionLoop(through: collection, min: min, max: max, steps: steps)
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
    
    @inlinable func indices(_ instruction: CollectionLoopInstruction<Self>) -> CollectionLoop<Self>.Indices {
        instruction.make(self).indices()
    }
    
    // MARK: Elements
    
    @inlinable func elements(_ instruction: CollectionLoopInstruction<Self>) -> CollectionLoop<Self>.Elements {
        instruction.make(self).elements()
    }
}
