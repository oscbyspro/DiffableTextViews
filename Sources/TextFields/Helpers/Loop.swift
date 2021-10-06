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
    
    // MARK: Stride
    
    @inlinable static func stride(through collection: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step = .forwards()) -> Self {
        var start = start ?? .closed(collection.startIndex)
        var end   = end   ??     .open(collection.endIndex)
        
        if step.forwards != (start <= end) {
            swap(&start, &end)
        }
        
        return Self(collection, start: start, end: end, step: step)
    }
    
    // MARK: Stroll
    
    @inlinable static func stroll(through collection: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step = .forwards()) -> Self {
        let start = start ?? (step.forwards ? .closed(collection.startIndex) : .open(collection.endIndex))
        let end   = end   ?? (step.forwards ? .open(collection.endIndex) : .closed(collection.startIndex))
        
        return Self(collection, start: start, end: end, step: step)
    }
    
    // MARK: Helpers
    
    @inlinable func next(_ index: Index, limit: Bound) -> Index? {
        base.index(index, offsetBy: step.distance, limitedBy: limit.position)
    }

    @inlinable func limitation() -> Bound {
        step.forwards ? Swift.max(start, end) : Swift.min(start, end)
    }
    
    @inlinable func validation(limit: Bound) -> (Index) -> Bool {
        switch (step.forwards, limit.open) {
        case (true,   true): return { $0 <  limit.position }
        case (true,  false): return { $0 <= limit.position }
        case (false,  true): return { $0 >  limit.position }
        case (false, false): return { $0 >= limit.position }
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
        let limit = limitation()
        let validate = validation(limit: limit)
        
        var current = start.position as Index?
        
        if start.open {
            current = next(current!, limit: limit)
        }
        
        return AnyIterator {
            guard let index = current, validate(index) else { return nil }
            
            defer { current = next(index, limit: limit) }
            return  index
        }
    }

    // MARK: - Components
        
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
        
        // MARK: Comparable
        
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
