//
//  CollectionLoopStride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

#warning("Maybe name: CollectionStrideInstruction")
public struct CollectionLoopStride<Collection: Swift.Collection> {
    public typealias Bound = Loops.Bound<Collection.Index>
    public typealias Interval = Loops.Interval<Collection.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Collection>
    
    // MARK: Properties
    
    public let start: Bound
    public let limit: Bound
    public let steps: Steps
    
    // MARK: Initializers
    
    @inlinable public init(start: Bound, limit: Bound, steps: Steps) {
        self.start = start
        self.limit = limit
        self.steps = steps
    }
    
    @inlinable public init(interval: Interval, steps: Steps) {
        self.start = steps.distance >= 0 ? interval.min : interval.max
        self.limit = steps.distance >= 0 ? interval.max : interval.min
        self.steps = steps
    }
    
    // MARK: Conversions
    
    @inlinable public func interval() -> Interval {
        Interval(min: min(start, limit), max: max(start, limit))
    }
}
