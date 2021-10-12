//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import Sequences

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
        var nextRange = newValue
        
        let x = field.reversed().reduce(into: String(), map: \.lhs.character)
        print(x)
        
        moveInsideContent(&nextRange)
        #warning("Can we calculate the jump over spacers without previous range?")
        moveAcrossSpacers(&nextRange, compare: range)
        
        return Selection(field, range: nextRange)
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

extension Selection {
    
    // MARK: Clamp Inside Content
    
    @inlinable func moveInsideContent(_ range: inout Range<Field.Index>) {
        let lowerBound = field.nearestContentIndex(from: range.lowerBound)
        let upperBound = field.nearestContentIndex(from: range.upperBound)
        
        range = lowerBound ..< upperBound
    }
}

extension Selection {
    
    // MARK: Ignore Spacers
    
    @inlinable func moveAcrossSpacers(_ next: inout Range<Field.Index>, compare previous: Range<Field.Index>) {
        func direction(_ position: (Range<Field.Index>) -> Field.Index) -> Direction? {
            .momentum(from: position(previous), to: position(next))
        }

        #warning("...")
        func position(_ start: Field.Index, attraction: Attraction, move direction: Direction?) -> Field.Index {
            guard let direction = direction else { return start }
            
            return field.firstIndex(in: .stride(start: .closed(start), step: direction.step), where: attraction.search) ?? start
        }

        let upperBound = position(next.upperBound, attraction: .backwards, move: direction(\.upperBound) ?? .backwards)
        var lowerBound = upperBound

        if next.isEmpty == false {
            lowerBound = position(next.lowerBound, attraction:  .forwards, move: direction(\.lowerBound) ??  .forwards)
        }

        next = lowerBound ..< upperBound
    }
    
    // MARK: Helpers
    
    @usableFromInline enum Direction {
        case forwards
        case backwards
        
        // MARK: Calculations
        
        @inlinable var step: Sequences.Step<Field> {
            self == .forwards ? .forwards : .backwards
        }
        
        // MARK: Initializers
        
        @inlinable static func momentum(from previous: Field.Index, to next: Field.Index) -> Direction? {
            guard next != previous else { return nil }
            
            return next > previous ? .forwards : .backwards
        }
    }
    
    @usableFromInline struct Attraction {
        
        // MARK: Properties
        
        @usableFromInline let search: (Field.Element) -> Bool
        
        // MARK: Initializers
        
        @inlinable init(search: @escaping (Field.Element) -> Bool) {
            self.search = search
        }
        
        @inlinable static var forwards: Self {
            Self.init(search: \.rhs.nonspacer)
        }
        
        @inlinable static var backwards: Self {
            Self.init(search: \.lhs.nonspacer)
        }
    }
}
