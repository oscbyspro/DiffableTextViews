//
//  CollectionStride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-07.
//

public struct CollectionStride<Collection: Swift.Collection>: Sequence {
    public typealias Index = Collection.Index
    public typealias Element = Collection.Element
    public typealias Bound = Loops.Bound<Collection.Index>
    public typealias Step = Loops.CollectionStrideStep<Collection>
    
    // MARK: Properties
    
    public let collection: Collection
    public let start: Bound
    public let destination: Bound
    public let step: Step
    
    // MARK: Initializers
    
    @inlinable public init(_ collection: Collection, from start: Bound, towards destination: Bound, step: Step) {
        self.collection = collection
        self.start = start
        self.destination = destination
        self.step = step
    }
    
    // MARK: Helpers
    
    @inlinable func limit() -> Bound {
        step.forwards ? Swift.max(start, destination) : Swift.min(start, destination)
    }
    
    @inlinable func validation(limit: Bound) -> (Index) -> Bool {
        step.forwards ? { index in index <= limit } : { index in index >= limit }
    }
    
    @inlinable func next(_ index: Index, limit: Bound) -> Index? {
        collection.index(index, offsetBy: step.distance, limitedBy: limit.element)
    }
    
    @inlinable func first(limit: Bound) -> Index? {
        start == start.element ? start.element : next(start.element, limit: limit)
    }
    
    // MARK: Iterators
    
    @inlinable public func indices() -> AnyIterator<Index> {
        let limit = limit()
        let validation = validation(limit: limit)
        var index = first(limit: limit)
        
        return AnyIterator {
            guard let position = index else { return nil }
            guard validation(position) else { return nil }
            
            defer { index = next(position, limit: limit) }
            
            return position
        }
    }
    
    @inlinable public func elements() -> AnyIterator<Element> {
        let indices = indices()
        
        return AnyIterator {
            indices.next().map({ collection[$0] })
        }
    }
    
    // MARK: Sequence
    
    @inlinable public func makeIterator() -> AnyIterator<Element> {
        elements()
    }
}
