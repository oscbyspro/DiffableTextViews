//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

#warning("Cleanup.")
#warning("Handle spacer jumps when range.lowerBound != range.upperBound.")
#warning("--> It should clamp unnecessary spacers, and jump correctly from clamped positions.")
@usableFromInline struct Selection {
    @usableFromInline typealias Field = Carets<Snapshot>
    @usableFromInline typealias Content = Field.Element
    @usableFromInline typealias Position = Field.Index
    
    // MARK: Storage
    
    @usableFromInline let field: Field
    @usableFromInline var range: Range<Position>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.field = snapshot.carets
        self.range = field.lastIndex ..< field.lastIndex
    }
    
    @inlinable init(_ field: Field, range: Range<Position>) {
        self.field = field
        self.range = range
    }

    // MARK: Offsets
    
    @inlinable func offset(at position: Position) -> Int {
        position.rhs?.offset ?? (position.lhs!.offset + 1)
    }
    
    @inlinable var offsets: Range<Int> {
        offset(at: range.lowerBound) ..< offset(at: range.upperBound)
    }
    
    // MARK: Update: Carets
    
    @inlinable func update(field newValue: Field) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .compare(.equatable(\.character))
            .inspect(.only(where: \.content))
            .produce(.overshoot)
        
        func symbol(content: Content) -> Symbol {
            content.rhs ?? .suffix(">")
        }
        
        func position(current: Field.SubSequence, next: Field.SubSequence) -> Position {
            next.view(symbol).suffix(alsoIn: current.view(symbol), options: options).startIndex
        }
        
        let nextUpperBound = position(current: field[range.upperBound...], next: newValue[...])
        let nextLowerBound = position(current: field[range], next: newValue[..<nextUpperBound])

        return Selection(newValue, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func update(snapshot newValue: Snapshot) -> Self {
        update(field: newValue.carets)
    }

    // MARK: Update: Range
    
    @inlinable func update(range newValue: Range<Position>) -> Self {
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        moveToContent(&nextLowerBound)
        moveToContent(&nextUpperBound)
                
        moveOverSpacers(&nextLowerBound, momentum: Momentum(from: range.lowerBound, to: nextLowerBound))
        moveOverSpacers(&nextUpperBound, momentum: Momentum(from: range.upperBound, to: nextUpperBound))
                
        return Selection(field, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func update(range newValue: Range<Snapshot.Index>) -> Self {
        let lowerBound = field.index(rhs: newValue.lowerBound)
        let upperBound = field.index(rhs: newValue.upperBound)
        
        return update(range: lowerBound ..< upperBound)
    }
    
    @inlinable func update(offsets newValue: Range<Int>) -> Self {
        typealias Path = (start: Position, offset: Int)
        
        var positions = [Position]()
        positions.reserveCapacity(5)
        positions.append(contentsOf: [field.firstIndex, field.lastIndex])
        positions.append(contentsOf: [range.lowerBound, range.upperBound])
        
        func path(from position: Position, to offset: Int) -> Path {
            Path(start: position, offset: offset - self.offset(at: position))
        }
        
        func position(at offset: Int, append: Bool) -> Position {
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
    
    @inlinable func update(position newValue: Position) -> Self {
        update(range: newValue ..< newValue)
    }
    
    @inlinable func update(position newValue: Snapshot.Index) -> Self {
        update(position: position(at: newValue))
    }
    
    // MARK: Helpers
    
    @inlinable func position(at snapshotIndex: Snapshot.Index) -> Position {
        field.index(rhs: snapshotIndex)
    }
    
    @inlinable func positions(in snapshotIndices: Range<Snapshot.Index>) -> Range<Position> {
        position(at: snapshotIndices.lowerBound) ..< position(at: snapshotIndices.upperBound)
    }
    
    @inlinable func next(_ position: Position) -> Position? {
        position < field.lastIndex ? field.index(after: position) : nil
    }
    
    @inlinable func prev(_ position: Position) -> Position? {
        position > field.firstIndex ? field.index(before: position) : nil
    }
    
    @inlinable func move(_ position: inout Position, step: (Position) -> Position?, while predicate: (Content) -> Bool) {
        while predicate(field[position]), let next = step(position) { position = next }
    }
    
    @inlinable func moveToContent(_ position: inout Position) {
        move(&position, step: next, while: { ($0.rhs?.attribute ?? .prefix) == .prefix })
        move(&position, step: prev, while: { ($0.lhs?.attribute ?? .suffix) == .suffix })
    }
}

#warning("This is super messy.")
#warning("I think it is better to handle lowerBound and upperBound simultaneously, to handle clamping and such.")
extension Selection {
    @inlinable func first(after position: Position, step: (Position) -> Position?, where predicate: (Content) -> Bool) -> Position? {
        var current = position
        
        while let other = step(current) {
            current = other
            
            if predicate(field[current]) { return current }
        }
        
        return nil
    }

    @usableFromInline func next(_ position: Position, where predicate: (Content) -> Bool) -> Position? {
        first(after: position, step: next(_:), where: predicate)
    }

    @usableFromInline func prev(_ position: Position, where predicate: (Content) -> Bool) -> Position? {
        first(after: position, step: prev(_:), where: predicate)
    }
    
    @inlinable func moveToNextOverSpacers(_ position: inout Position) {
        guard field[position].lhs?.attribute == .spacer else { return }
            
        func destination(_ content: Content?) -> Bool {
            content?.lhs.map(\.content) ?? false
        }
        
        if let destination = next(position, where: destination(_:)) {
            position = destination
        }
    }
    
    @inlinable func moveToPrevOverSpacers(_ position: inout Position) {
        guard field[position].lhs?.attribute == .spacer else { return }
        
        func destination(_ content: Content?) -> Bool {
            content?.lhs.map({ $0.prefix || $0.content }) ?? true
        }
        
        if let destination = prev(position, where: destination(_:)) {
            position = destination
        }
    }
    
    @inlinable func moveOverSpacers(_ position: inout Position, momentum: Momentum) {
        switch momentum {
        case .left: moveToPrevOverSpacers(&position)
        case .right: moveToNextOverSpacers(&position)
        case .none: break
        }
    }
    
    @usableFromInline enum Momentum {
        case left
        case right
        case none

        @inlinable init(from prev: Position, to next: Position) {
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
