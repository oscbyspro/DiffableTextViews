//
//  Collection+CollectionStride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-07.
//

public extension Collection {
    // MARK: Make
    
    @inlinable func sequence(_ instruction: CollectionStrideInstruction<Self>) -> CollectionStride<Self> {
        instruction.make(self)
    }
}

public extension Collection {
    // MARK: First
    
    @inlinable func first(
        from start: Bound<Index>? = nil,
        step: CollectionStride<Self>.Step = .forwards,
        where predicate: (Element) -> Bool = { _ in true }
    ) -> Element? {
        firstIndex(from: start, step: step, where: predicate).map({ index in self[index] })
    }
    
    // MARK: First Index
    
    @inlinable func firstIndex(
        from start: Bound<Index>? = nil,
        step: CollectionStride<Self>.Step = .forwards,
        where predicate: (Element) -> Bool = { _ in true }
    ) -> Index? {
        let start = start ?? (step.forwards ? .closed(startIndex) : .open(endIndex))
            
        for index in sequence(.stride(from: start, towards: nil, step: step)).indices() {
            if predicate(self[index]) { return index }
        }
        
        return nil
    }
}
