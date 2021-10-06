//
//  Loop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

struct Loop<Base: Collection>: Sequence {
    typealias Index = Base.Index
    typealias Element = Base.Element
    typealias Step = LoopStep<Base>
    typealias Bound = LoopBound<Index>
    typealias Bounds = LoopBounds<Index>
    
    // MARK: Storage
    
    let base: Base
    let start: Bound
    let end: Bound
    let step: Step

    // MARK: Initializers

    @inlinable init(_ base: Base, start: Bound, end: Bound, step: Step) {
        precondition(step.distance != 0)
        
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    // MARK: Initializers: Move
    
    @inlinable static func move(through collection: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step = .forwards()) -> Self {
        let start = start ?? (step.forwards ? .closed(collection.startIndex) : .open(collection.endIndex))
        let end   = end   ?? (step.forwards ? .open(collection.endIndex) : .closed(collection.startIndex))
        
        return Self(collection, start: start, end: end, step: step)
    }
    
    // MARK: Initializers: Stride
    
    @inlinable static func stride(through collection: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step = .forwards()) -> Self {
        var start = start ?? .closed(collection.startIndex)
        var end   = end   ??     .open(collection.endIndex)
        
        if step.forwards != (start <= end) {
            swap(&start, &end)
        }
        
        return Self(collection, start: start, end: end, step: step)
    }
    
    // MARK: Helpers
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: step.distance, limitedBy: end.position)
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
        let bounds = Bounds(unordered: (start, end))
        
        var position = start.position as Index?
        
        if !bounds.contains(position!) {
            position = next(position!)
        }
        
        return AnyIterator {
            guard let index = position, bounds.contains(index) else { return nil }
            
            defer { position = next(index) }
            return  index
        }
    }
}

// MARK: -

struct LoopStep<Base: Collection>: Equatable {
    let distance: Int
    
    // MARK: Initializers

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

// MARK: -

struct LoopBound<Position: Comparable>: Comparable {
    let position: Position
    let open: Bool
    
    // MARK: Initializers

    @inlinable init(_ position: Position, open: Bool) {
        self.position = position
        self.open = open
    }
    
    @inlinable static func open(_ position: Position) -> Self {
        Self(position, open: true)
    }
    
    @inlinable static func closed(_ position: Position) -> Self {
        Self(position, open: false)
    }
    
    // MARK: Comparable
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }
    
    // MARK: Comparisons: ==
    
    @inlinable static func == (bound: Self, position: Position) -> Bool {
        !bound.open && bound.position == position
    }
    
    @inlinable static func == (position: Position, bound: Self) -> Bool {
        !bound.open && bound.position == position
    }
    
    // MARK: Comparisons: <
    
    @inlinable static func < (bound: Self, position: Position) -> Bool {
        bound.position < position
    }
    
    @inlinable static func < (position: Position, bound: Self) -> Bool {
        position > bound.position
    }
    
    // MARK: Comparisons: <=
    
    @inlinable static func <= (bound: Self, position: Position) -> Bool {
        bound.open ? bound.position < position : bound.position <= position
    }
    
    @inlinable static func <= (position: Position, bound: Self) -> Bool {
        bound.open ? position < bound.position : position <= bound.position
    }
    
    // MARK: Comparisons: >
    
    
    @inlinable static func > (bound: Self, position: Position) -> Bool {
        bound.position > position
    }
    
    @inlinable static func > (position: Position, bound: Self) -> Bool {
        position > bound.position
    }
    
    // MARK: Comparisons: >=
    
    @inlinable static func >= (bound: Self, position: Position) -> Bool {
        bound.open ? bound.position > position : bound.position >= position
    }
    
    @inlinable static func >= (position: Position, bound: Self) -> Bool {
        bound.open ? position > bound.position : position >= bound.position
    }
}

// MARK: -

struct LoopBounds<Position: Comparable> {
    let lowerBound: LoopBound<Position>
    let upperBound: LoopBound<Position>
    
    // MARK: Initializers
    
    @inlinable init(lowerBound: LoopBound<Position>, upperBound: LoopBound<Position>) {
        precondition(lowerBound <= upperBound)
        
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    @inlinable init(unordered bounds: (LoopBound<Position>, LoopBound<Position>)) {
        self.lowerBound = min(bounds.0, bounds.1)
        self.upperBound = max(bounds.0, bounds.1)
    }
    
    // MARK: Utilities
    
    @inlinable func contains(_ position: Position) -> Bool {
        lowerBound <= position && position <= upperBound
    }
}

// MARK: - Collection + Loop

extension Collection {
    @inlinable func firstIndex(from start: LoopBound<Index>, step: LoopStep<Self>, where predicate: (Element) -> Bool = { _ in true }) -> Index? {
        for index in Loop.move(through: self, from: start, step: step).makeIndexIterator() where predicate(self[index]) {
            return index
        }
        
        return nil
    }
}


