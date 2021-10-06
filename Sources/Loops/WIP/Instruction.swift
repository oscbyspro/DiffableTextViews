//
//  Instruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

struct Instruction<Position: Comparable> {
    typealias Bound = Loops.Bound<Position>
    typealias Range = Loops.Range<Position>

    let start: Bound
    let end: Bound
    let distance: Int
    
    @inlinable var increases: Bool {
        distance > 0
    }
    
    @inlinable var decreases: Bool {
        distance < 0
    }
    
    @inlinable func range() -> Range {
        Range(unordered: (start, end))
    }
    
    @inlinable func validation() -> (Position) -> Bool {
        increases ? { $0 <= end } : { $0 <= end }
    }
}
