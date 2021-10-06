//
//  BasicLoop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct StrideLoop<Base: Collection>: Sequence {
    public typealias Element = Base.Element
    public typealias Index = Base.Index
    public typealias Bound = Loops.Bound<Index>
    public typealias Step = Loops.Step<Base>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let start: Bound
    @usableFromInline let end: Bound
    @usableFromInline let step: Step
    
    // MARK: Initializers
        
    @inlinable public init(_ base: Base, start: Bound, end: Bound, step: Step) {
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    // MARK: Helpers
    
    @inlinable func makeIndexIterator() -> AnyIterator<Index> {
        StrideIndexLoop(base, start: start, end: end, step: step).makeIterator()
    }
    
    // MARK: Iterators
    
    @inlinable public func makeIterator() -> AnyIterator<Element> {
        let indexIterator = makeIndexIterator()
        
        return AnyIterator {
            guard let index = indexIterator.next() else { return nil }

            return base[index]
        }
    }
}

// MARK: -

public struct StrideIndexLoop<Base: Collection>: Sequence {
    public typealias Index = Base.Index
    public typealias Bound = Loops.Bound<Index>
    public typealias Range = Loops.Range<Index>
    public typealias Step = Loops.Step<Base>

    // MARK: Properties
        
    @usableFromInline let base: Base
    @usableFromInline let start: Bound
    @usableFromInline let end: Bound
    @usableFromInline let step: Step
    
    // MARK: Initializers

    @inlinable public init(_ base: Base, start: Bound, end: Bound, step: Step) {
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    // MARK: Helpers
    
    @inlinable func next(_ index: Index) -> Index? {
        base.index(index, offsetBy: step.distance, limitedBy: end.position)
    }
    
    // MARK: Iterators
    
    @inlinable public func makeIterator() -> AnyIterator<Index> {
        let range = Range(unordered: (start, end))
        
        var position = start.position as Index?
        
        if range.contains(position!) == false {
            position = next(position!)
        }
        
        return AnyIterator {
            guard let index = position, range.contains(index) else { return nil }
            
            defer { position = next(index) }
            return  index
        }
    }
}

