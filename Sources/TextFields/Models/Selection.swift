//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

#error("Cleanup. Messy. Dumb name conventions.")
#warning("Handle spacer jumps when range.lowerBound != range.upperBound.")
#warning("--> It should clamp unnecessary spacers, and jump correctly from clamped positions.")
@usableFromInline struct Selection {
    @usableFromInline let field: Field
    @usableFromInline var range: Range<Field.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ layout: Layout = Layout()) {
        self.field = Field(layout)
        self.range = field.lastIndex ..< field.lastIndex
    }
    
    @inlinable init(_ field: Field, range: Range<Field.Index>) {
        self.field = field
        self.range = range
    }

    // MARK: Offsets
    
    @inlinable var offsets: Range<Int> {
        range.map(bounds: \.offset)
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
    
    @inlinable func update(range newValue: Range<Field.Index>) -> Self {
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        moveToContent(&nextLowerBound)
        moveToContent(&nextUpperBound)
                
        moveOverSpacers(&nextLowerBound, momentum: Momentum(from: range.lowerBound, to: nextLowerBound))
        moveOverSpacers(&nextUpperBound, momentum: Momentum(from: range.upperBound, to: nextUpperBound))
                
        return Selection(field, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func update(range newValue: Range<Layout.Index>) -> Self {
        update(range: newValue.map(bounds: field.index(rhs:)))
    }
    
    @inlinable func update(range newValue: Range<Int>) -> Self {
        typealias Path = (start: Field.Index, offset: Int)
        
        var positions: [Field.Index] = []
        positions.reserveCapacity(5)
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
        
        return update(range: lowerBound ..< upperBound)
    }
    
    // MARK: Update: Position
    
    @inlinable func update(range newValue: Field.Index) -> Self {
        update(range: newValue ..< newValue)
    }
    
    @inlinable func update(range newValue: Layout.Index) -> Self {
        update(range: newValue ..< newValue)
    }
    
    // MARK: Helpers
    
    #warning("Move this to Field, or similar.")
    @inlinable func moveToContent(_ position: inout Field.Index) {
        if let destination = field.firstIndex(after: position, where: { !$0.rhs.suffix }) {
            position = destination
        }
        
        if let destination = field.firstIndex(before: position, where: { !$0.lhs.prefix }) {
            position = destination
        }
    }
}

#warning("This is super messy.")
#warning("I think it is better to handle lowerBound and upperBound simultaneously, to handle clamping and such.")
extension Selection {
    @inlinable func moveToNextOverSpacers(_ position: inout Field.Index) {
        guard field[position].lhs.spacer else { return }
        
        if let destination = field.firstIndex(after: position, where: \.lhs.content) {
            position = destination
        }
    }
    
    @inlinable func moveToPrevOverSpacers(_ position: inout Field.Index) {
        guard field[position].lhs.spacer else { return }
        
        if let destination = field.firstIndex(before: position, where: { $0.lhs.prefix || $0.lhs.content }) {
            position = destination
        }
    }
    
    @inlinable func moveOverSpacers(_ position: inout Field.Index, momentum: Momentum) {
        switch momentum {
        case .left: moveToPrevOverSpacers(&position)
        case .right: moveToNextOverSpacers(&position)
        case .none: break
        }
    }
    
    #warning("Remove, maybe.")
    @usableFromInline enum Momentum {
        case left
        case right
        case none

        @inlinable init(from prev: Field.Index, to next: Field.Index) {
            if next < prev {
                self = .left
            } else if next > prev {
                self = .right
            } else {
                self = .none
            }
        }
    }
}
