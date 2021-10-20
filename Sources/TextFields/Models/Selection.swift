//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

// MARK: - Selection

@usableFromInline struct Selection {
    @usableFromInline typealias Index = Field.Index
    @usableFromInline typealias Element = Field.Element
    @usableFromInline typealias Direction = Walkthrough<Field>.Step
    
    // MARK: Properties
    
    @usableFromInline let field: Field
    @usableFromInline var range: Range<Index>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.field = Field(snapshot)
        self.range = field.lastIndex ..< field.lastIndex
    }
    
    @inlinable init(_ field: Field, range: Range<Index>) {
        self.field = field
        self.range = range
    }
    
    // MARK: Descriptions
    
    @inlinable var offsets: Range<Int> {
        range.map(bounds: \.offset)
    }
    
    // MARK: Update: Field
    
    @inlinable func translate(to newValue: Field) -> Self {
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .inspect(.only(\.content))
            .compare(.equatable(\.character))
        
        func position(from current: Field.SubSequence, to next: Field.SubSequence) -> Index {
            next.lazy.map(\.rhs).suffix(alsoIn: current.lazy.map(\.rhs), options: options).startIndex
        }
        
        // --------------------------------- //
        
        let nextUpperBound = position(from: field[range.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: field[range], to: newValue[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Selection(newValue, range: nextLowerBound ..< nextUpperBound).moveToContent()
    }
    
    @inlinable func translate(to newValue: Snapshot) -> Self {
        translate(to: Field(newValue))
    }

    // MARK: Update: Range
    
    @inlinable func update(with newValue: Range<Index>) -> Self {
        move(to: newValue).moveToContent()
    }
    
    @inlinable func update(with newValue: Range<Snapshot.Index>) -> Self {
        update(with: newValue.map(bounds: field.index(rhs:)))
    }
    
    @inlinable func update(with newValue: Range<Int>) -> Self {
        typealias Path = (start: Index, offset: Int)
        
        var positions = [Index](size: 5)
        positions.append(contentsOf: [field.firstIndex, field.lastIndex])
        positions.append(contentsOf: [range.lowerBound, range.upperBound])
        
        func path(from position: Index, to offset: Int) -> Path {
            Path(start: position, offset: offset - position.offset)
        }
                
        func position(at offset: Int, append: Bool) -> Index {
            let paths: [Path] = positions.map({ path(from: $0, to: offset) })
            let shortest: Path = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position: Index = field.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                positions.append(position)
            }
            
            return position
        }
        
        let lowerBound: Index = position(at: newValue.lowerBound, append: true)
        let upperBound: Index = position(at: newValue.upperBound, append: false)
                        
        return update(with: lowerBound ..< upperBound)
    }
    
    // MARK: Update: Position
    
    @inlinable func update(with newValue: Index) -> Self {
        update(with: newValue ..< newValue)
    }
    
    @inlinable func update(with newValue: Snapshot.Index) -> Self {
        update(with: newValue ..< newValue)
    }
    
    // MARK: Transformations
    
    @inlinable func map(_ transform: (inout Selection) -> Void) -> Selection {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: - Movements

extension Selection {
    
    // MARK: To Content
    
    @inlinable func moveToContent() -> Selection {
        func position(_ position: Index) -> Index {
            var position = position
            
            func condition() -> Bool {
                let element = field[position]; return element.lhs.noncontent && element.rhs.noncontent
            }
                        
            func move(_ direction: Direction, towards predicate: (Element) -> Bool) {
                position = field.firstIndex(in: .stride(start: .closed(position), step: direction), where: predicate) ?? position
            }
            
            if condition() {
                move(.backwards, towards: { $0.lhs.content || $0.lhs.prefix })
            }
            
            if condition() {
                move(.forwards,  towards: { $0.rhs.content || $0.rhs.suffix })
            }
            
            return position
        }
        
        // --------------------------------- //
        
        let lowerBound = position(range.lowerBound)
        let upperBound = position(range.upperBound)
        
        // --------------------------------- //

        return map({ $0.range = lowerBound ..< upperBound })
    }
    
    // MARK: To, Across Spacers
    
    @inlinable func move(to newValue: Range<Index>) -> Selection {
        func momentum(from first: Index, to second: Index) -> Direction? {
            if      first < second { return  .forwards }
            else if first > second { return .backwards }
            else                   { return      .none }
        }
        
        func position(_ positionIn: (Range<Index>) -> Index, preference: Direction, where predicate: (Element) -> Bool) -> Index {
            let position = positionIn(newValue)
            let momentum = momentum(from: positionIn(range), to: position) ?? preference
    
            return field.firstIndex(in: .stride(start: .closed(position), step: momentum), where: predicate) ?? position
        }
        
        // --------------------------------- //
        
        let upperBound = position(\.upperBound, preference: .backwards, where: \.lhs.nonspacer)
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, where: \.rhs.nonspacer)
        }
        
        // --------------------------------- //
        
        return map({ $0.range = lowerBound ..< upperBound })
    }
}
