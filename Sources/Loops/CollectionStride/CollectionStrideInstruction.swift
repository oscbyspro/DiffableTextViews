//
//  CollectionStrideInstruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-07.
//

public struct CollectionStrideInstruction<Collection: Swift.Collection> {
    public typealias Bound = Loops.Bound<Collection.Index>
    public typealias Step = Loops.CollectionStrideStep<Collection>
    public typealias Stride = Loops.CollectionStride<Collection>
    
    // MARK: Properties
    
    @usableFromInline let make: (Collection) -> Stride
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Collection) -> Stride) {
        self.make = make
    }
}

public extension CollectionStrideInstruction {
    // MARK: Stride
    
    @inlinable static func stride(from start: Bound? = nil, towards destination: Bound? = nil, step: Step = .forwards) -> Self {
        func make(collection: Collection) -> Stride {
            let start       = start       ?? (step.forwards ? .closed(collection.startIndex) : .open(collection.endIndex))
            let destination = destination ?? (step.forwards ? .open(collection.endIndex) : .closed(collection.startIndex))

            return Stride(collection, from: start, towards: destination, step: step)
        }
        
        return Self(make)
    }
}

public extension CollectionStrideInstruction {
    // MARK: Interval
    
    @inlinable static func interval(from lowerBound: Bound? = nil, to upperBound: Bound? = nil, step: Step = .forwards) -> Self {
        func make(collection: Collection) -> Stride {
            var lowerBound = lowerBound ?? .closed(collection.startIndex)
            var upperBound = upperBound ??     .open(collection.endIndex)

            precondition(lowerBound <= upperBound)
            
            if step.forwards != (lowerBound <= upperBound) {
                swap(&lowerBound, &upperBound)
            }

            return Stride(collection, from: lowerBound, towards: upperBound, step: step)
        }
        
        return Self(make)
    }
}
