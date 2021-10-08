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
    public typealias Instruction = Sequences.CollectionStrideInstruction<Base>
    
    public typealias IndexLoop = AnyIterator<Index>
    public typealias ElementLoop = AnyIterator<Element>
    public typealias ContentLoop = AnyIterator<(index: Index, element: Element)>
    
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
    
    @inlinable func indices() -> IndexLoop {
        var position = movement.start.element as Index?
        
        if !interval.contains(position!) {
            position = stride(position!)
        }
        
        return .init {
            guard let index = position, interval.contains(index) else { return nil }

            defer { position = stride(index) }
            return  index
        }
    }
    
    // MARK: Elements
    
    @inlinable func elements() -> ElementLoop {
        let indices = indices()
        
        return .init {
            indices.next().map({ index in base[index] })
        }
    }
    
    // MARK: Content
    
    @inlinable func content() -> ContentLoop {
        let indices = indices()
        
        return .init {
            indices.next().map({ index in (index, base[index]) })
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
    
    @inlinable init(unchecked distance: Int) {
        precondition(distance != .zero)
        
        self.distance = distance
    }
    
    // MARK: Calculations
    
    @inlinable public var forwards: Bool {
        distance > 0
    }
    
    @inlinable public var backwards: Bool {
        distance < 0
    }
    
    // MARK: Utilities
    
    @inlinable public func reversed() -> Self where Base: BidirectionalCollection {
        Self(unchecked: -distance)
    }
}

public extension CollectionStrideSteps {
    // MARK: Forwards
    
    @inlinable static var forwards: Self {
        Self(unchecked: +1)
    }
    
    @inlinable static func forwards(_ distance: UInt) -> Self {
        Self(unchecked: +Int(distance))
    }
}

public extension CollectionStrideSteps where Base: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable static var backwards: Self {
        Self(unchecked: -1)
    }
    
    @inlinable static func backwards(_ distance: UInt) -> Self {
        Self(unchecked: -Int(distance))
    }
}

public extension CollectionStrideSteps where Base: BidirectionalCollection {
    @inlinable static func distance(_ distance: Int) -> Self {
        Self(unchecked: -Int(distance))
    }
}

// MARK: - Instruction

public struct CollectionStrideInstruction<Collection: Swift.Collection> {
    public typealias Bound = Sequences.Bound<Collection.Index>
    public typealias Steps = Sequences.CollectionStrideSteps<Collection>
    public typealias Stride = Sequences.CollectionStrideInstruction<Collection>
    public typealias Loop = Sequences.CollectionStride<Collection>
    
    // MARK: Properties
    
    @usableFromInline let make: (Collection) -> Loop
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Collection) -> Loop) {
        self.make = make
    }
}

public extension CollectionStrideInstruction {
    // MARK: Interval
    
    @inlinable static func interval(from min: Bound? = nil, to max: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionStride(collection, min: min, max: max, steps: steps)
        }
    }
    
    // MARK: Stride
    
    @inlinable static func stride(from start: Bound? = nil, to limit: Bound? = nil, steps: Steps = .forwards) -> Self {
        Self { collection in
            CollectionStride(collection, start: start, limit: limit, steps: steps)
        }
    }
}

// MARK: -

public extension Collection {
    typealias Stride = CollectionStride<Self>
    
    // MARK: Indices
    
    @inlinable func indices(_ instruction: Stride.Instruction) -> Stride.IndexLoop {
        instruction.make(self).indices()
    }
    
    // MARK: Elements
    
    @inlinable func elements(_ instruction: Stride.Instruction) -> Stride.ElementLoop {
        instruction.make(self).elements()
    }
    
    // MARK: Content
    
    @inlinable func content(_ instruction: Stride.Instruction) -> Stride.ContentLoop {
        instruction.make(self).content()
    }
}
