//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

// MARK: - Selection

@usableFromInline struct Selection {
    
    // MARK: Properties
    
    @usableFromInline let field: Field
    @usableFromInline let range: Range<Field.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.field = Field(snapshot)
        self.range = field.lastIndex ..< field.lastIndex
    }
    
    @inlinable init(_ field: Field, range: Range<Field.Index>) {
        self.field = field
        self.range = range
    }
    
    // MARK: Update: Field
    
    @inlinable func translate(to newValue: Field) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .inspect(.only(\.content))
            .compare(.equatable(\.character))
        
        func position(from current: Field.SubSequence, to next: Field.SubSequence) -> Field.Index {
            next.lazy.map(\.rhs).suffix(alsoIn: current.lazy.map(\.rhs), options: options).startIndex
        }
        
        let nextUpperBound = position(from: field[range.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: field[range], to: newValue[..<nextUpperBound])
        
        return Selection(newValue, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func translate(to newValue: Snapshot) -> Self {
        translate(to: Field(newValue))
    }

    // MARK: Update: Range
    
    @inlinable func update(with newValue: Range<Field.Index>) -> Self {
        var next = newValue
        moveInoutRangeToContent(&next)
        moveInoutRangeAcrossSpacers(&next)
        
        return Selection(field, range: next)
    }
    
    @inlinable func update(with newValue: Range<Snapshot.Index>) -> Self {
        update(with: newValue.map(bounds: field.index(rhs:)))
    }
    
    @inlinable func update(with newValue: Range<Int>) -> Self {
        typealias Path = (start: Field.Index, offset: Int)
        
        var positions = [Field.Index](size: 5)
        positions.append(contentsOf: [field.firstIndex, field.lastIndex])
        positions.append(contentsOf: [range.lowerBound, range.upperBound])
        
        func path(from position: Field.Index, to offset: Int) -> Path {
            Path(start: position, offset: offset - position.offset)
        }
                
        func position(at offset: Int, append: Bool) -> Field.Index {
            let paths: [Path] = positions.map({ path(from: $0, to: offset) })
            let shortest: Path = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position: Field.Index = field.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                positions.append(position)
            }
            
            return position
        }
        
        let lowerBound: Field.Index = position(at: newValue.lowerBound, append: true)
        let upperBound: Field.Index = position(at: newValue.upperBound, append: false)
        
        return update(with: lowerBound ..< upperBound)
    }
    
    // MARK: Update: Position
    
    @inlinable func update(with newValue: Field.Index) -> Self {
        update(with: newValue ..< newValue)
    }
    
    @inlinable func update(with newValue: Snapshot.Index) -> Self {
        update(with: newValue ..< newValue)
    }
}

// MARK: - Helpers

extension Selection {
    
    // MARK: Move To Content
    
    @inlinable func moveInoutRangeToContent(_ inoutRange: inout Range<Field.Index>) {
        func position(_ positionIn: (Range<Field.Index>) -> Field.Index) -> Field.Index {
            var position = positionIn(inoutRange)
                    
            if field[position].rhs.prefix, let next = field.firstIndex(in: .stride(start: .closed(position), step:  .forwards), where: \.rhs.content) {
                position = next
            }
            
            if field[position].lhs.suffix, let next = field.firstIndex(in: .stride(start: .closed(position), step: .backwards), where: \.lhs.content) {
                position = next
            }
            
            return position
        }

        inoutRange = position(\.lowerBound) ..< position(\.upperBound)
    }
    
    // MARK: Move Across Spacers

    @inlinable func moveInoutRangeAcrossSpacers(_ inoutRange: inout Range<Field.Index>) {
        typealias Direction = Walkthrough<Field>.Step
                
        func direction(from first: Field.Index, to second: Field.Index) -> Direction? {
            if      first < second { return  .forwards }
            else if first > second { return .backwards }
            else                   { return      .none }
        }
        
        func position(_ positionIn: (Range<Field.Index>) -> Field.Index, preference: Direction, where predicate: (Field.Element) -> Bool) -> Field.Index {
            let start = positionIn(inoutRange)
            let direction = direction(from: positionIn(range), to: start) ?? preference
            
            return field.firstIndex(in: .stride(start: .closed(start), step: direction), where: predicate) ?? start
        }
                
        let upperBound = position(\.upperBound, preference: .backwards, where: \.lhs.nonspacer)
        var lowerBound = upperBound
        
        if !inoutRange.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, where: \.rhs.nonspacer)
        }
                
        inoutRange = lowerBound ..< upperBound
    }
}
