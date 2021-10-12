//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

@usableFromInline struct Selection {
    @usableFromInline let field: Field
    @usableFromInline let range: Range<Field.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ layout: Layout = Layout()) {
        self.field = Field(layout)
        self.range = field.lastIndex ..< field.lastIndex
    }
    
    @inlinable init(_ field: Field, range: Range<Field.Index>) {
        self.field = field
        self.range = range
    }
    
    // MARK: Update: Carets
    
    @inlinable func convert(to newValue: Field) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .compare(.equatable(\.character))
            .inspect(.only(where: \.content))
            .produce(.overshoot)
        
        func position(current: Field.SubSequence, next: Field.SubSequence) -> Field.Index {
            next.lazy.map(\.rhs).suffix(alsoIn: current.lazy.map(\.rhs), options: options).startIndex
        }
        
        let nextUpperBound = position(current: field[range.upperBound...], next: newValue[...])
        let nextLowerBound = position(current: field[range], next: newValue[..<nextUpperBound])

        return Selection(newValue, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func convert(to newValue: Layout) -> Self {
        convert(to: Field(newValue))
    }

    // MARK: Update: Range
    
    @inlinable func update(with newValue: Range<Field.Index>) -> Self {
        var next = newValue
        next = moveToContent(next)
        next = moveOverSpacers(next)
        
        return Selection(field, range: next)
    }
    
    @inlinable func update(with newValue: Range<Layout.Index>) -> Self {
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
            let paths = positions.map({ path(from: $0, to: offset) })
            let shortest = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position = field.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                positions.append(position)
            }
            
            return position
        }
        
        let lowerBound = position(at: newValue.lowerBound, append: true)
        let upperBound = position(at: newValue.upperBound, append: false)
        
        return update(with: lowerBound ..< upperBound)
    }
    
    // MARK: Update: Position
    
    @inlinable func update(with newValue: Field.Index) -> Self {
        update(with: newValue ..< newValue)
    }
    
    @inlinable func update(with newValue: Layout.Index) -> Self {
        update(with: newValue ..< newValue)
    }
}

// MARK: - Helpers

extension Selection {
    
    // MARK: Move To Content
    
    @inlinable func moveToContent(_ other: Range<Field.Index>) -> Range<Field.Index> {
        let lowerBound = field.nearestContentIndex(from: other.lowerBound)
        let upperBound = field.nearestContentIndex(from: other.upperBound)

        return lowerBound ..< upperBound
    }
}

extension Selection {
    
    // MARK: Move Over Spacers
    
    @inlinable func moveOverSpacers(_ other: Range<Field.Index>) -> Range<Field.Index> {
        func position(_ bound: (Range<Field.Index>) -> Field.Index, attraction: Field.Direction) -> Field.Index {
            let current = bound(range); let next = bound(other)
            let direction = .init(from: current, to: next) ?? attraction
            return field.firstIndex(from: next, direction: direction, attraction: attraction, where: \.nonspacer) ?? next
        }
        
        let upperBound = position(\.upperBound, attraction: .backwards)
        var lowerBound = upperBound
        
        if !other.isEmpty {
            lowerBound = position(\.lowerBound, attraction:  .forwards)
        }
        
        return lowerBound ..< upperBound
    }
}
