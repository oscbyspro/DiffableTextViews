//
//  CollectionLoop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

#warning("Consider renaming it.")
public struct CollectionLoop<Collection: Swift.Collection> {
    public typealias Index = Collection.Index
    public typealias Element = Collection.Element

    public typealias Bound = Loops.Bound<Collection.Index>
    public typealias Interval = Loops.Interval<Collection.Index>
    public typealias Steps = Loops.CollectionLoopSteps<Collection>
    public typealias Stride = Loops.CollectionLoopStride<Collection>

    public typealias Indices = AnyIterator<Collection.Index>
    public typealias Elements = AnyIterator<Collection.Element>
    
    // MARK: Properties
    
    @usableFromInline let collection: Collection
    @usableFromInline let interval: Interval
    @usableFromInline let stride: Stride

    // MARK: Initializers
        
    @inlinable init(_ collection: Collection, interval: Interval, stride: Stride) {
        self.collection = collection
        self.interval = interval
        self.stride = stride
    }
    
    @inlinable init(_ collection: Collection, interval: Interval, steps: Steps) {
        self.init(collection, interval: interval, stride: Stride(interval: interval, steps: steps))
    }
    
    @inlinable init(_ collection: Collection, stride: Stride) {
        self.init(collection, interval: Interval(unordered: (stride.start, stride.limit)), stride: stride)
    }
        
    // MARK: Helpers
    
    @inlinable func stride(_ index: Index) -> Index? {
        collection.index(index, offsetBy: stride.steps.distance, limitedBy: stride.limit.element)
    }
}

public extension CollectionLoop {
    // MARK: Indices
    
    @inlinable func indices() -> Indices {
        var position = stride.start.element as Index?
        
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
    
    @inlinable func elements() -> Elements {
        let indices = indices()
        
        return AnyIterator {
            indices.next().map({ index in collection[index] })
        }
    }
}

public extension CollectionLoop {
    // MARK: Interval
    
    @inlinable init(_ collection: Collection, min: Bound? = nil, max: Bound? = nil, steps: Steps = .forwards) {
        let min = min ?? .closed(collection.startIndex)
        let max = max ??     .open(collection.endIndex)
        
        self.init(collection, interval: Interval(min: min, max: max), steps: steps)
    }
    
    // MARK: Stride
    
    @inlinable init(_ collection: Collection, start: Bound? = nil, limit: Bound? = nil, steps: Steps = .forwards) {
        let start = start ?? (steps.forwards ? .closed(collection.startIndex) : .open(collection.endIndex))
        let limit = limit ?? (steps.forwards ? .open(collection.endIndex) : .closed(collection.startIndex))
                
        self.init(collection, stride: Stride(start: start, limit: limit, steps: steps))
    }
}
