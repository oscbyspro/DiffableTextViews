//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

#warning("Handle spacer jumps when range.lowerBound != range.upperBound.")
#warning("--> It should clamp unnecessary spacers, and jump correctly from clamped positions.")
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
            next.view(\.rhs).suffix(alsoIn: current.view(\.rhs), options: options).startIndex
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
        #warning("Is 'previous: range' required?")
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
        let lowerBound = field.nearestIndexInsideContentBounds(from: range.lowerBound)
        let upperBound = field.nearestIndexInsideContentBounds(from: range.upperBound)
        
        range = lowerBound ..< upperBound
    }
}

#warning("This is super messy.")
extension Selection {
    // MARK: Ignore Spacers
    
    @inlinable func moveAcrossSpacers(_ next: inout Range<Field.Index>, compare previous: Range<Field.Index>) {
        func position(_ position: Field.Index, forward: Bool, observe symbol: (Field.Element) -> Symbol) -> Field.Index {
            let end: (Field.Element) -> Bool = {
                forward ? { $0.rhs.suffix } : { $0.lhs.suffix }
            }()
            
            return field.firstIndex(from: position, forward: forward, where: { symbol($0).content || end($0) }) ?? position
        }
        
        let lowerBound: Field.Index
        let upperBound: Field.Index
        
        let lowerIntent = Intent(from: range.lowerBound, to: next.lowerBound)
        let upperIntent = Intent(from: range.upperBound, to: next.upperBound)
        
        if next.isEmpty {
            lowerBound = position(next.lowerBound, forward: (lowerIntent ?? .backward) == .forward, observe: \.lhs)
            upperBound = position(next.upperBound, forward: (upperIntent ?? .backward) == .forward, observe: \.lhs)
        } else {
            #warning("Only this one is different.")
            lowerBound = position(next.lowerBound, forward: (lowerIntent ??  .forward) == .forward, observe: \.rhs)
            upperBound = position(next.upperBound, forward: (upperIntent ?? .backward) == .forward, observe: \.lhs)
        }
        
        next = lowerBound ..< upperBound
    }

    @usableFromInline enum Intent {
        case forward
        case backward

        @inlinable init?(from prev: Field.Index, to next: Field.Index) {
            if next < prev {
                self = .backward
            } else if next > prev {
                self = .forward
            } else {
                return nil
            }
        }
    }
}
