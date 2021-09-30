//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

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
    
    // MARK: Interoperabilities
    
    @inlinable func position(at snapshotIndex: Snapshot.Index) -> Position {
        field.index(rhs: snapshotIndex)
    }
    
    @inlinable func positions(in snapshotIndices: Range<Snapshot.Index>) -> Range<Position> {
        position(at: snapshotIndices.lowerBound) ..< position(at: snapshotIndices.upperBound)
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

    // MARK: Helpers
    
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
