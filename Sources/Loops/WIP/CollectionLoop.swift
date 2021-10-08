//
//  CollectionLoop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionLoop<Base: Collection>: Sequence {
    public typealias Element = Base.Element
    public typealias Index = Base.Index
    public typealias Bound = Loops.Bound<Base.Index>
    public typealias Interval = Loops.Interval<Base.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Base>
    
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
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: movement.steps.distance, limitedBy: movement.limit.element)
    }
        
    // MARK: Iterators
    
    @inlinable public func indices() -> AnyIterator<Index> {
        var position = movement.start.element as Index?
        
        if !interval.contains(position!) {
            position = next(position!)
        }
        
        return AnyIterator {
            guard let index = position, interval.contains(index) else { return nil }
            
            defer {
                position = next(index)
            }
            
            return index
        }
    }
    
    @inlinable public func elements() -> AnyIterator<Element> {
        let indices = indices()
        
        return AnyIterator {
            indices.next().map({ index in base[index] })
        }
        
    }
    
    // MARK: Sequence
    
    @inlinable public func makeIterator() -> AnyIterator<Element> {
        elements()
    }
    
    // MARK: Components
    
    @usableFromInline struct Movement {
        @usableFromInline let start: Bound
        @usableFromInline let limit: Bound
        @usableFromInline let steps: Steps
        
        @inlinable init(start: Bound, limit: Bound, steps: Steps) {            
            self.start = start
            self.limit = limit
            self.steps = steps
        }
        
        @inlinable init(interval: Interval, steps: Steps) {
            self.start = steps.distance >= 0 ? interval.min : interval.max
            self.limit = steps.distance >= 0 ? interval.max : interval.min
            self.steps = steps
        }
    }
}

public extension CollectionLoop {
    // MARK: Strides
    
    @inlinable static func stride(through base: Base, min: Bound? = nil, max: Bound? = nil, steps: Steps = .forwards) -> Self {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        return Self(base, interval: Interval(min: min, max: max), steps: steps)
    }
    
    @inlinable static func stride(through base: Base, from start: Bound? = nil, towards limit: Bound? = nil, steps: Steps = .forwards) -> Self {
        let start = start ?? (steps.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let limit = limit ?? (steps.forwards ? .open(base.endIndex) : .closed(base.startIndex))
        
        return Self(base, interval: Interval(unordered: (start, limit)), steps: steps)
    }
}
