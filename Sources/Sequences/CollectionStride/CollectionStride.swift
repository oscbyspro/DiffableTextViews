//
//  CollectionStride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionStride<Base: Collection> {
    public typealias Index = Base.Index
    public typealias Element = Base.Element

    public typealias Bound = Sequences.Bound<Base.Index>
    public typealias Interval = Sequences.Interval<Base.Index>
    public typealias Steps = Sequences.CollectionStrideSteps<Base>
    public typealias Movement = Sequences.CollectionStrideMovement<Base>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let interval: Interval
    @usableFromInline let movement: Movement

    // MARK: Initializers
        
    @inlinable init(_ base: Base, interval: Interval, movement: Movement) {
        self.base = base
        self.interval = interval
        self.movement = movement
    }
    
    @inlinable init(_ base: Base, interval: Interval, steps: Steps) {
        self.init(base, interval: interval, movement: Movement(interval: interval, steps: steps))
    }
    
    @inlinable init(_ base: Base, movement: Movement) {
        self.init(base, interval: Interval(unordered: (movement.start, movement.limit)), movement: movement)
    }
        
    // MARK: Helpers
    
    @inlinable func stride(_ index: Index) -> Index? {
        base.index(index, offsetBy: movement.steps.distance, limitedBy: movement.limit.element)
    }
}

public extension CollectionStride {
    // MARK: Indices
    
    @inlinable func indices() -> AnyIterator<Index> {
        var position = movement.start.element as Index?
        
        if !interval.contains(position!) {
            position = stride(position!)
        }
        
        return AnyIterator {
            guard let index = position, interval.contains(index) else { return nil }

            defer {
                position = stride(index)
            }
            
            return index
        }
    }
    
    // MARK: Elements
    
    @inlinable func elements() -> AnyIterator<Element> {
        let indices = indices()
        
        return AnyIterator {
            indices.next().map({ index in base[index] })
        }
    }
}

public extension CollectionStride {
    // MARK: Interval
    
    @inlinable init(_ base: Base, min: Bound? = nil, max: Bound? = nil, steps: Steps = .forwards) {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        self.init(base, interval: Interval(min: min, max: max), steps: steps)
    }
    
    // MARK: Walk
    
    @inlinable init(_ base: Base, start: Bound? = nil, limit: Bound? = nil, steps: Steps = .forwards) {
        let start = start ?? (steps.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let limit = limit ?? (steps.forwards ? .open(base.endIndex) : .closed(base.startIndex))
                
        self.init(base, movement: Movement(start: start, limit: limit, steps: steps))
    }
}
