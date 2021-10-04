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
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        nextLowerBound = field.nearestIndexInsideContentBounds(from: nextLowerBound)
        nextUpperBound = field.nearestIndexInsideContentBounds(from: nextUpperBound)
        
        #warning("Clean up this mess.")
        
        // lowerBound
        if let momentum = Momentum(from: range.lowerBound, to: nextLowerBound) {
            moveOverSpacers(&nextLowerBound, forward: momentum == .forward, left: nextLowerBound == nextUpperBound)
        }
        
        // upperBound
        if let momentum = Momentum(from: range.upperBound, to: nextUpperBound) {
            moveOverSpacers(&nextUpperBound, forward: momentum == .forward, left: true)
        }
        
        return Selection(field, range: nextLowerBound ..< nextUpperBound)
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

#warning("This is super messy.")
#warning("I think it is better to handle lowerBound and upperBound simultaneously, to handle clamping and such.")
extension Selection {
    @inlinable func moveOverSpacers(_ position: inout Field.Index, forward: Bool, left: Bool) -> Field.Index? {
        let end: (Field.Element) -> Bool = {
            forward ? { $0.rhs.suffix } : { $0.lhs.prefix }
        }()
        
        let predicate: (Field.Element) -> Bool = {
            left ? { $0.lhs.content } : { $0.rhs.content }
        }()
        
        if let destination = field.firstIndex(from: position, forward: forward, where: { predicate($0) || end($0) }) {
            position = destination
        }
    }
    
    @usableFromInline enum Momentum {
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

/*
 @inlinable func moveToNextOverSpacers(_ position: inout Field.Index) {
     if let destination = field[position...].firstIndex(where: { $0.lhs.content || $0.rhs.suffix }) {
         position = destination
     }
 }
 
 @inlinable func moveToPrevOverSpacers(_ position: inout Field.Index, equality: Bool) {
     func point(element: Field.Element) -> Bool {
         element.lhs.content || element.rhs.prefix
     }

     func range(element: Field.Element) -> Bool {
         element.rhs.content || element.rhs.prefix
     }

     if let destination = field.firstIndex(from: position, forward: false, where: equality ? point : range) {
         position = destination
     }
 }
 */

#warning("if lowerBound == upperBound")
/*
 
 position: move to firstIndex(where: \.lhs.content, direction: position_momentum) // direction: .left
 
 */

#warning("If lowerBound != upperBound")
/*
 
 lowerBound: move to firstIndex(where: \.rhs.content, direction: lowerBound_momentum) // direction: .left
 upperBound: move to firstIndex(where: \.lhs.content, direction: upperBound_momentum) // direction: .right
 
 */

#warning("use momentum to decide wether to move forward or backward, use")
