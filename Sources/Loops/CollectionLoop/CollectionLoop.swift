//
//  CollectionLoop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionLoop<Base: Collection> {
    public typealias Index = Base.Index
    public typealias Element = Base.Element

    public typealias Bound = Loops.Bound<Base.Index>
    public typealias Interval = Loops.Interval<Base.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Base>
    public typealias Stride = Loops.CollectionLoopStride<Base>

    public typealias Indices = AnyIterator<Base.Index>
    public typealias Elements = AnyIterator<Base.Element>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let stride: Stride
    @usableFromInline let interval: Interval

    // MARK: Initializers
        
    @inlinable init(_ base: Base, stride: Stride, interval: Interval) {
        self.base = base
        self.stride = stride
        self.interval = interval
    }
    
    @inlinable init(_ base: Base, stride: Stride) {
        self.init(base, stride: stride, interval: Interval(unordered: (stride.start, stride.limit)))
    }
    
    @inlinable init(_ base: Base, interval: Interval, steps: Steps) {
        self.init(base, stride: Stride(interval: interval, steps: steps), interval: interval)
    }
        
    // MARK: Helpers
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: stride.steps.distance, limitedBy: stride.limit.element)
    }
}

public extension CollectionLoop {
    // MARK: Indices
    
    @inlinable func indices() -> Indices {
        var position = stride.start.element as Index?
        
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
    
    // MARK: Elements
    
    @inlinable func elements() -> Elements {
        let indices = indices()
        
        return AnyIterator {
            indices.next().map({ index in base[index] })
        }
    }
}

public extension CollectionLoop {
    // MARK: Stride
    
    @inlinable init(through base: Base, from start: Bound? = nil, to limit: Bound? = nil, steps: Steps = .forwards) {
        let start = start ?? (steps.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let limit = limit ?? (steps.forwards ? .open(base.endIndex) : .closed(base.startIndex))
                
        self.init(base, stride: Stride(start: start, limit: limit, steps: steps))
    }
    
    // MARK: Interval
    
    @inlinable init(through base: Base, from min: Bound? = nil, to max: Bound? = nil, steps: Steps = .forwards) {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        self.init(base, interval: Interval(min: min, max: max), steps: steps)
    }
}
