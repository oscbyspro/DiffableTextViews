//
//  Walkthrough.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

// MARK: - Walkthrough

public struct Walkthrough<Base: Collection> {
    public typealias Index = Base.Index
    public typealias Element = Base.Element
    public typealias Content = (index: Base.Index, element: Base.Element)
    
    public typealias Bound = Sequences.Bound<Base.Index>
    public typealias Interval = Sequences.Interval<Base.Index>
    public typealias Path = Sequences.Path<Base.Index>
    
    public typealias Step = Sequences.WalkthroughStep<Base>
    public typealias Instructions = Sequences.WalkthroughInstructions<Base>
    public typealias Sequence<Value> = Sequences.WalkthroughSequence<Base, Value>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let interval: Interval
    @usableFromInline let path: Path
    @usableFromInline let step: Step

    // MARK: Initializers
        
    @inlinable init(_ base: Base, interval: Interval, path: Path, step: Step) {
        self.base = base
        self.interval = interval
        self.path = path
        self.step = step
    }
    
    @inlinable init(_ base: Base, path: Path, step: Step) {
        self.init(base, interval: Interval(unordered: (path.start, path.limit)), path: path, step: step)
    }
    
    @inlinable init(_ base: Base, interval: Interval, step: Step) {
        self.init(base, interval: interval, path: Path(interval: interval, stride: step.distance), step: step)
    }
    
    // MARK: Helpers
    
    @inlinable func next(_ index: Base.Index) -> Base.Index? {
        base.index(index, offsetBy: step.distance, limitedBy: path.limit.element)
    }
}

extension Walkthrough {
    // MARK: Indices
    
    @inlinable public func indices() -> AnySequence<Index> {
        var start = path.start.element as Index?
        
        if step.nowhere {
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

extension Walkthrough {
    // MARK: Stride
    
    @inlinable public init(_ base: Base, start: Bound? = nil, limit: Bound? = nil, step: Step = .forwards) {
        let start = start ?? (step.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let limit = limit ?? (step.forwards ? .open(base.endIndex) : .closed(base.startIndex))
                
        self.init(base, path: Path(start: start, limit: limit), step: step)
    }
    
    // MARK: Interval
    
    @inlinable public init(_ base: Base, min: Bound? = nil, max: Bound? = nil, step: Step = .forwards) {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        self.init(base, interval: Interval(min: min, max: max), step: step)
    }
}

// MARK: - Step

public struct WalkthroughStep<Base: Collection> {
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

extension WalkthroughStep {
    // MARK: Forwards
    
    @inlinable public static var forwards: Self {
        Self(+1)
    }
    
    @inlinable public static func forwards(_ distance: UInt) -> Self {
        Self(+Int(distance))
    }
}

extension WalkthroughStep where Base: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable public static var backwards: Self {
        Self(-1)
    }
    
    @inlinable public static func backwards(_ distance: UInt) -> Self {
        Self(-Int(distance))
    }
}

extension WalkthroughStep where Base: BidirectionalCollection {
    // MARK: Distance
    
    @inlinable public static func distance(_ distance: Int) -> Self {
        Self(-Int(distance))
    }
}

// MARK: - Instructions

public struct WalkthroughInstructions<Base: Swift.Collection> {
    public typealias Bound = Sequences.Bound<Base.Index>
    public typealias Step = Sequences.WalkthroughStep<Base>
    
    // MARK: Properties
    
    @usableFromInline let make: (Base) ->  Walkthrough<Base>
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Base) -> Walkthrough<Base>) {
        self.make = make
    }
    
    // MARK: Instructions
    
    @inlinable public static func stride(start: Bound? = nil, limit: Bound? = nil, step: Step = .forwards) -> Self {
        Self({ collection in .init(collection, start: start, limit: limit, step: step) })
    }
        
    @inlinable public static func interval(min: Bound? = nil, max: Bound? = nil, step: Step = .forwards) -> Self {
        Self({ collection in .init(collection, min: min, max: max, step: step) })
    }
}

// MARK: - Sequence

public struct WalkthroughSequence<Base: Collection, Value> {
    public typealias Instance<T> = WalkthroughSequence<Base, T>
    
    // MARK: Properties
    
    @usableFromInline let make: (Walkthrough<Base>) -> AnySequence<Value>
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Walkthrough<Base>) -> AnySequence<Value>) {
        self.make = make
    }
    
    // MARK: Sequences
    
    @inlinable public static var indices: Instance<Base.Index> {
        Instance({ stride in stride.indices() })
    }

    @inlinable public static var elements: Instance<Base.Element> {
        Instance({ stride in stride.elements() })
    }

    @inlinable public static var contents: Instance<(index: Base.Index, element: Base.Element)> {
        Instance({ stride in stride.contents() })
    }
}

// MARK: - Collection

extension Collection {
    public typealias Walkthrough = Sequences.Walkthrough<Self>
    
    // MARK: Sequences

    @inlinable public func sequence(in walkthrough: Walkthrough.Instructions) -> AnySequence<Element> {
        walkthrough.make(self).elements()
    }
    
    @inlinable public func sequence<Value>(of values: Walkthrough.Sequence<Value>, in walkthrough: Walkthrough.Instructions) -> AnySequence<Value> {
        values.make(walkthrough.make(self))
    }
}
