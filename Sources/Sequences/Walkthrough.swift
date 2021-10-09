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
    
    public typealias Stride = Sequences.WalkthroughStride<Base>
    public typealias Instructions = Sequences.WalkthroughInstructions<Base>
    public typealias Sequence<Value> = Sequences.WalkthroughSequence<Base, Value>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let interval: Interval
    @usableFromInline let path: Path
    @usableFromInline let stride: Stride

    // MARK: Initializers
        
    @inlinable init(_ base: Base, interval: Interval, path: Path, stride: Stride) {
        self.base = base
        self.interval = interval
        self.path = path
        self.stride = stride
    }
    
    // MARK: Initializers: Path
    
    @inlinable init(_ base: Base, path: Path, stride: Stride) {
        self.init(base, interval: Interval(unordered: (path.start, path.end)), path: path, stride: stride)
    }
    
    @inlinable public init(_ base: Base, start: Bound? = nil, end: Bound? = nil, stride: Stride = .forwards) {
        let start = start ?? (stride.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let   end =   end ?? (stride.forwards ? .open(base.endIndex) : .closed(base.startIndex))
                
        self.init(base, path: Path(start: start, end: end), stride: stride)
    }
    
    // MARK: Initializers: Interval
    
    @inlinable init(_ base: Base, interval: Interval, stride: Stride) {
        self.init(base, interval: interval, path: Path(interval: interval, stride: stride.distance), stride: stride)
    }

    @inlinable public init(_ base: Base, min: Bound? = nil, max: Bound? = nil, stride: Stride = .forwards) {
        let min = min ?? .closed(base.startIndex)
        let max = max ??     .open(base.endIndex)
        
        self.init(base, interval: Interval(min: min, max: max), stride: stride)
    }

    // MARK: Helpers
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: stride.distance, limitedBy: path.end.element)
    }

    // MARK: Indices
    
    @inlinable public func indices() -> AnySequence<Index> {
        var start = path.start.element as Index?
        
        if stride.nowhere {
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

// MARK: - Stride

public struct WalkthroughStride<Base: Collection> {
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

extension WalkthroughStride {
    // MARK: Forwards
    
    @inlinable public static var forwards: Self {
        Self(+1)
    }
    
    @inlinable public static func forwards(_ distance: UInt) -> Self {
        Self(+Int(distance))
    }
}

extension WalkthroughStride where Base: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable public static var backwards: Self {
        Self(-1)
    }
    
    @inlinable public static func backwards(_ distance: UInt) -> Self {
        Self(-Int(distance))
    }
}

extension WalkthroughStride where Base: BidirectionalCollection {
    // MARK: Distance
    
    @inlinable public static func stride(_ distance: Int) -> Self {
        Self(-Int(distance))
    }
}

// MARK: - Instructions

public struct WalkthroughInstructions<Base: Swift.Collection> {
    public typealias Bound = Sequences.IndexBound<Base>
    public typealias Walkthrough = Sequences.Walkthrough<Base>
    public typealias Stride = Sequences.WalkthroughStride<Base>
    
    // MARK: Properties
    
    @usableFromInline let make: (Base) ->  Walkthrough
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Base) -> Walkthrough) {
        self.make = make
    }
}

extension WalkthroughInstructions {
    // MARK: Forwards
    
    @inlinable public static var forwards: Self {
        Self({ collection in .init(collection, min: nil, max: nil, stride: .forwards) })
    }
    
    @inlinable public static func forwards(_ distance: UInt) -> Self {
        Self({ collection in .init(collection, min: nil, max: nil, stride: .forwards(distance)) })
    }
}

extension WalkthroughInstructions where Base: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable public static var backwards: Self {
        Self({ collection in .init(collection, min: nil, max: nil, stride: .backwards) })
    }
    
    @inlinable public static func backwards(_ distance: UInt) -> Self {
        Self({ collection in .init(collection, min: nil, max: nil, stride: .backwards(distance)) })
    }
}

extension WalkthroughInstructions where Base: BidirectionalCollection {
    // MARK: Distance
    
    @inlinable public static func stride(_ distance: Int) -> Self {
        Self({ collection in .init(collection, min: nil, max: nil, stride: .stride(distance)) })
    }
}

extension WalkthroughInstructions {
    // MARK: Path
    
    @inlinable public static func path(start: Bound?, end: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, start: start?(collection), end: end?(collection), stride: stride) })
    }

    @inlinable public static func path(end: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, start: nil, end: end?(collection), stride: stride) })
    }

    @inlinable public static func path(start: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, start: start?(collection), end: nil, stride: stride) })
    }
}

extension WalkthroughInstructions {
    // MARK: Interval
        
    @inlinable public static func interval(min: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, min: min?(collection), max: nil, stride: stride) })
    }
    
    @inlinable public static func interval(max: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, min: nil, max: max?(collection), stride: stride) })
    }
    
    @inlinable public static func interval(min: Bound?, max: Bound?, stride: Stride = .forwards) -> Self {
        Self({ collection in .init(collection, min: min?(collection), max: max?(collection), stride: stride) })
    }
}

// MARK: - Sequence

public struct WalkthroughSequence<Base: Collection, Value> {
    public typealias Instance<T> = WalkthroughSequence<Base, T>
    public typealias Walkthrough = Sequences.Walkthrough<Base>
    
    // MARK: Properties
    
    @usableFromInline let make: (Walkthrough) -> AnySequence<Value>
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (Walkthrough) -> AnySequence<Value>) {
        self.make = make
    }
    
    // MARK: Sequences
    
    @inlinable public static var indices: Instance<Walkthrough.Index> {
        .init({ stride in stride.indices() })
    }

    @inlinable public static var elements: Instance<Walkthrough.Element> {
        .init({ stride in stride.elements() })
    }

    @inlinable public static var contents: Instance<Walkthrough.Content> {
        .init({ stride in stride.contents() })
    }
}

// MARK: - Collection

extension Collection {
    public typealias Walkthrough = Sequences.Walkthrough<Self>
    
    // MARK: Sequences
    
    @inlinable public func sequence<Value>(of values: Walkthrough.Sequence<Value>, in walkthrough: Walkthrough.Instructions = .forwards) -> AnySequence<Value> {
        values.make(walkthrough.make(self))
    }
}
