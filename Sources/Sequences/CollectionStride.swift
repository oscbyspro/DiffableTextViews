//
//  CollectionStride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

// MARK: - CollectionStride

public struct CollectionStride<Base: Collection> {
    public typealias Index = Base.Index
    public typealias Element = Base.Element
    public typealias Content = (index: Base.Index, element: Base.Element)
    
    public typealias Bound = Sequences.Bound<Base.Index>
    public typealias Interval = Sequences.Interval<Base.Index>
    
    public typealias Steps = Sequences.CollectionStrideSteps<Base>
    public typealias Movement = Sequences.CollectionStrideMovement<Base>
    
    public typealias Instruction = Sequences.CollectionStrideInstruction<Base>
    public typealias Sequence<Item> = Sequences.CollectionStrideSequence<Base, Item>
    
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
    
    @inlinable func next(_ index: Base.Index) -> Base.Index? {
        base.index(index, offsetBy: movement.steps.distance, limitedBy: movement.limit.element)
    }
}

extension CollectionStride {
    // MARK: Indices
    
    @inlinable public func indices() -> AnySequence<Index> {
        var start = movement.start.element as Index?
        
        if movement.steps.nowhere {
            start = nil
        }
        
        if let index = start, interval.contains(index) {
            start = next(index)
        }
        
        return AnySequence { () -> AnyIterator<Index> in
            var position = start
            
            return AnyIterator { () -> Optional<Index> in
                guard let index = position, interval.contains(index) else { return nil }

                defer { position = next(index) }
                return  index
            }
        }
    }
    
    // MARK: Elements
    
    @inlinable public func elements() -> AnySequence<Element> {
        let indices = indices()
                
        return AnySequence { () -> AnyIterator<Element> in
            let iterator = indices.makeIterator()
            
            return AnyIterator { () -> Optional<Element> in
                iterator.next().map({ index in base[index] })
            }
        }
    }
    
    // MARK: Content
    
    @inlinable public func contents() -> AnySequence<Content> {
        let indices = indices()
        
        return AnySequence { () -> AnyIterator<Content> in
            let iterator = indices.makeIterator()
            
            return AnyIterator { () -> Optional<Content> in
                iterator.next().map({ index in (index, base[index]) })
            }
        }
    }
}

extension CollectionStride {
    // MARK: Stride
    
    @inlinable public init(_ base: Base, start: Bound? = nil, limit: Bound? = nil, steps: Steps = .forwards) {
        let start = start ?? (steps.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let limit = limit ?? (steps.forwards ? .open(base.endIndex) : .closed(base.startIndex))
                
        self.init(base, movement: Movement(start: start, limit: limit, steps: steps))
    }
    
    // MARK: Interval
    
    @inlinable public init(_ base: Base, min: Bound? = nil, max: Bound? = nil, steps: Steps = .forwards) {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        self.init(base, interval: Interval(min: min, max: max), steps: steps)
    }
}

// MARK: - Movement

public struct CollectionStrideMovement<Base: Collection> {
    public typealias Bound = Sequences.Bound<Base.Index>
    public typealias Interval = Sequences.Interval<Base.Index>
    public typealias Steps = Sequences.CollectionStrideSteps<Base>
    
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

// MARK: - Steps

public struct CollectionStrideSteps<Base: Collection> {
    // MARK: Properties
    
    public let distance: Int
    
    // MARK: Initializers
    
    @inlinable init(_ distance: Int) {
        self.distance = distance
    }
    
    // MARK: Calculations
    
    @inlinable public var forwards: Bool {
        distance > 0
    }
    
    @inlinable public var backwards: Bool {
        distance < 0
    }
    
    @inlinable public var nowhere: Bool {
        distance == 0
    }
    
    // MARK: Utilities
    
    @inlinable public func reversed() -> Self where Base: BidirectionalCollection {
        Self(-distance)
    }
}

extension CollectionStrideSteps {
    // MARK: Forwards
    
    @inlinable public static var forwards: Self {
        Self(+1)
    }
    
    @inlinable public static func forwards(_ distance: UInt) -> Self {
        Self(+Int(distance))
    }
}

extension CollectionStrideSteps where Base: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable public static var backwards: Self {
        Self(-1)
    }
    
    @inlinable public static func backwards(_ distance: UInt) -> Self {
        Self(-Int(distance))
    }
}

extension CollectionStrideSteps where Base: BidirectionalCollection {
    // MARK: Distance
    
    @inlinable public static func distance(_ distance: Int) -> Self {
        Self(-Int(distance))
    }
}

// MARK: - Instruction

public struct CollectionStrideInstruction<Collection: Swift.Collection> {
    public typealias Bound = Sequences.Bound<Collection.Index>
    public typealias Stride = Sequences.CollectionStride<Collection>
    public typealias Steps = Sequences.CollectionStrideSteps<Collection>
    
    // MARK: Properties
    
    @usableFromInline let make: (Collection) -> Stride
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Collection) -> Stride) {
        self.make = make
    }
    
    // MARK: Instructions
    
    @inlinable public static func stride(from start: Bound? = nil, to limit: Bound? = nil, stepping steps: Steps = .forwards) -> Self {
        Self({ collection in .init(collection, start: start, limit: limit, steps: steps) })
    }
        
    @inlinable public static func interval(from min: Bound? = nil, to max: Bound? = nil, stepping steps: Steps = .forwards) -> Self {
        Self({ collection in .init(collection, min: min, max: max, steps: steps) })
    }
}

// MARK: - Sequence

public struct CollectionStrideSequence<Base: Collection, Value> {
    public typealias Stride = CollectionStride<Base>
    public typealias Instance<T> = CollectionStrideSequence<Base, T>
    
    // MARK: Properties
    
    @usableFromInline let make: (Base) -> AnySequence<Value>
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Base) -> AnySequence<Value>) {
        self.make = make
    }
    
    // MARK: Sequences
    
    @inlinable public static func indices(in stride: Stride.Instruction) -> Instance<Stride.Index> {
        .init({ collection in stride.make(collection).indices() })
    }
    
    @inlinable public static func elements(in stride: Stride.Instruction) -> Instance<Stride.Element> {
        .init({ collection in stride.make(collection).elements() })
    }
    
    @inlinable public static func contents(in stride: Stride.Instruction) -> Instance<Stride.Content> {
        .init({ collection in stride.make(collection).contents() })
    }
}

// MARK: - Collection

extension Collection {
    // MARK: Sequence
    
    @inlinable public func sequence<Value>(of values: CollectionStride<Self>.Sequence<Value>) -> AnySequence<Value> {
        values.make(self)
    }
}
