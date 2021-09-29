//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

#warning("Give updater methods specialized parameter signatures.")
@usableFromInline struct Selection {
    @usableFromInline typealias Carets = TextFields.Carets<Snapshot>
    @usableFromInline typealias Caret = Carets.Element
    @usableFromInline typealias Position = Carets.Index
    
    // MARK: Storage
    
    @usableFromInline let positions: Carets
    @usableFromInline var range: Range<Position>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.positions = snapshot.carets
        self.range = positions.lastIndex ..< positions.lastIndex
    }
    
    @inlinable init(_ positions: Carets, range: Range<Position>) {
        self.positions = positions
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
        positions.index(rhs: snapshotIndex)
    }
    
    @inlinable func positions(in snapshotIndices: Range<Snapshot.Index>) -> Range<Position> {
        position(at: snapshotIndices.lowerBound) ..< position(at: snapshotIndices.upperBound)
    }
    
    // MARK: Update: Carets
    
    @inlinable func updating(snapshot newValue: Snapshot) -> Self {
        updating(carets: newValue.carets)
    }
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .compare(.equatable(\.character))
            .inspect(.only(where: \.content))
            .produce(.overshoot)
        
        func symbol(caret: Caret) -> Symbol {
            caret.rhs ?? .suffix(">")
        }
        
        func position(current: Carets.SubSequence, next: Carets.SubSequence) -> Position {
            next.insights(symbol).suffix(alsoIn: current.insights(symbol), options: options).startIndex
        }
        
        let nextUpperBound = position(current: positions[range.upperBound...], next: newValue[...])
        let nextLowerBound = position(current: positions[range], next: newValue[..<nextUpperBound])

        return Selection(newValue, range: nextLowerBound ..< nextUpperBound)
    }

    // MARK: Update: Range
    
    @inlinable func updating(range newValue: Range<Snapshot.Index>) -> Self {
        let lowerBound = positions.index(rhs: newValue.lowerBound)
        let upperBound = positions.index(rhs: newValue.upperBound)
        
        return updating(range: lowerBound ..< upperBound)
    }
    
    @inlinable func updating(range newValue: Range<Position>) -> Self {
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        moveToContent(&nextLowerBound)
        moveToContent(&nextUpperBound)
                
        return Selection(positions, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func updating(position newValue: Position) -> Self {
        updating(range: newValue ..< newValue)
    }
    
    #warning("Maybe make into an algorithm.")
    #warning("Make something like this in the UITextField extension.")
    @inlinable func updating(offsets newValue: Range<Int>) -> Self {
        typealias Path = (start: Position, offset: Int)
        
        var knowns = Array<Position>(capacity: 5)
        knowns += [range.lowerBound, range.upperBound]
        knowns += [positions.firstIndex, positions.lastIndex]
        
        func path(from position: Position, to destination: Int) -> Path {
            Path(start: position, offset: destination - offset(at: position))
        }
        
        func position(at offset: Int, append: Bool) -> Position {
            let paths = knowns.map({ path(from: $0, to: offset) })
            let shortest = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position = positions.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                knowns.append(position)
            }
            
            return position
        }
        
        let lowerBound = position(at: newValue.lowerBound, append: true)
        let upperBound = position(at: newValue.upperBound, append: false)
        
        return updating(range: lowerBound ..< upperBound)
    }

    // MARK: Update: Range - Helpers
    
    @inlinable func next(_ position: Position) -> Position? {
        position < positions.lastIndex ? positions.index(after: position) : nil
    }
    
    @inlinable func prev(_ position: Position) -> Position? {
        position > positions.firstIndex ? positions.index(before: position) : nil
    }
    
    @inlinable func move(_ position: inout Position, step: (Position) -> Position?, while predicate: (Caret) -> Bool) {
        while predicate(positions[position]), let next = step(position) { position = next }
    }
    
    @inlinable func moveToContent(_ position: inout Position) {
        move(&position, step: next, while: { ($0.rhs?.attribute ?? .prefix) == .prefix })
        move(&position, step: prev, while: { ($0.lhs?.attribute ?? .suffix) == .suffix })
    }
}
