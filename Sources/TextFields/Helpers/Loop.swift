//
//  Loop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

struct Loop<Base: Collection>: Sequence {
    typealias Index = Base.Index
    typealias Element = Base.Element
    
    // MARK: Storage
    
    let base: Base
    let start: Bound
    let end: Bound
    let step: Step

    // MARK: Initialization
    
    @inlinable init(_ base: Base, start: Bound, end: Bound, step: Step) {
        precondition(step.distance != 0)
        
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    @inlinable init(_ base: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step) {
        let start = start ?? (step.forwards ? .closed(base.startIndex) : .open(base.endIndex))
        let end   = end   ?? (step.forwards ? .open(base.endIndex) : .closed(base.startIndex))
        
        self.init(base, start: start, end: end, step: step)
    }

    // MARK: Helpers
    
    @inlinable func limit() -> Index {
        step.forwards ? base.endIndex : base.startIndex
    }

    @inlinable func next(_ index: Index, limit: Index) -> Index? {
        base.index(index, offsetBy: step.distance, limitedBy: limit)
    }
    
    @inlinable func validate() -> (Index) -> Bool {
        let last = step.forwards ? Swift.max(start, end) : Swift.min(start, end)
        
        switch (step.forwards, last.open) {
        case (true,   true): return { $0 <  last.position }
        case (true,  false): return { $0 <= last.position }
        case (false,  true): return { $0 >  last.position }
        case (false, false): return { $0 >= last.position }
        }
    }
    
    // MARK: Iterators
        
    @inlinable func makeIterator() -> AnyIterator<Element> {
        let indexIterator = makeIndexIterator()
        
        return AnyIterator {
            guard let next = indexIterator.next() else { return nil }
                        
            return base[next]
        }
    }
    
    @inlinable func makeIndexIterator() -> AnyIterator<Index> {
        let limit = limit()
        let validate = validate()

        var current = start.position as Index?
        
        if start.open {
            current = next(current!, limit: limit)
        }
        
        return AnyIterator {
            guard let index = current, validate(index) else { return nil }
            defer { current = next(index, limit: limit) }
            return index
        }
    }

    // MARK: Components
        
    struct Bound: Comparable {
        let position: Index
        let open: Bool
        
        // MARK: Initialization
        
        @inlinable init(_ position: Index, open: Bool) {
            self.position = position
            self.open = open
        }
        
        @inlinable static func open(_ position: Index) -> Self {
            Self(position, open: true)
        }
        
        @inlinable static func closed(_ position: Index) -> Self {
            Self(position, open: false)
        }
        
        // MARK: Protocol: Comparable
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.position < rhs.position
        }
    }
    
    struct Step: Equatable {
        let distance: Int
        
        // MARK: Initialization
                
        @inlinable init(_ distance: Int) {
            self.distance = distance
        }
                
        @inlinable static func distance(_ distance: Int) -> Self {
            Self(distance)
        }
                
        @inlinable static func forwards() -> Self {
            Self(+1)
        }
        
        @inlinable static func backwards() -> Self where Base: BidirectionalCollection {
            Self(-1)
        }
        
        // MARK: Utilities
        
        @inlinable var forwards: Bool {
            distance > 0
        }
        
        @inlinable var backwards: Bool {
            distance < 0
        }
    }
}
