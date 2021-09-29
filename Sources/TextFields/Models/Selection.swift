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
    
    @usableFromInline let carets: Carets
    @usableFromInline var range: Range<Position>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = snapshot.carets
        self.range = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ carets: Carets, range: Range<Position>) {
        self.carets = carets
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
        carets.index(rhs: snapshotIndex)
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
        
        let nextUpperBound = position(current: carets[range.upperBound...], next: newValue[...])
        let nextLowerBound = position(current: carets[range], next: newValue[..<nextUpperBound])

        return Selection(newValue, range: nextLowerBound ..< nextUpperBound)
    }

    // MARK: Update: Range
    
    @inlinable func updating(range newValue: Range<Snapshot.Index>) -> Self {
        let lowerBound = carets.index(rhs: newValue.lowerBound)
        let upperBound = carets.index(rhs: newValue.upperBound)
        
        return updating(range: lowerBound ..< upperBound)
    }
    
    @inlinable func updating(range newValue: Range<Position>) -> Self {
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        moveToContent(&nextLowerBound)
        moveToContent(&nextUpperBound)
                
        return Selection(carets, range: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func updating(position newValue: Position) -> Self {
        updating(range: newValue ..< newValue)
    }
    
    #warning("Maybe make into an algorithm.")
    #warning("Make something like this in the UITextField extension.")
    @inlinable func updating(offsets newValue: Range<Int>) -> Self {
        typealias Path = (start: Position, offset: Int)
        
        var positions = Array<Carets.Index>(capacity: 5)
        positions.append(contentsOf: [carets.firstIndex, carets.lastIndex])
        positions.append(contentsOf: [range.lowerBound, range.upperBound])
        
        func path(from position: Position, to destination: Int) -> Path {
            Path(start: position, offset: destination - offset(at: position))
        }
        
        func position(at offset: Int, append: Bool) -> Position {
            let paths = positions.map({ path(from: $0, to: offset) })
            let shortest = paths.min(by: { abs($0.offset) < abs($1.offset) })!
            let position = carets.index(shortest.start, offsetBy: shortest.offset)
            
            if append {
                positions.append(position)
            }
            
            return position
        }
        
        let lowerBound = position(at: newValue.lowerBound, append: true)
        let upperBound = position(at: newValue.upperBound, append: false)
        
        return updating(range: lowerBound ..< upperBound)
    }

    // MARK: Update: Range - Helpers
    
    @inlinable func next(_ position: Position) -> Position? {
        position < carets.lastIndex ? carets.index(after: position) : nil
    }
    
    @inlinable func prev(_ position: Position) -> Position? {
        position > carets.firstIndex ? carets.index(before: position) : nil
    }
    
    @inlinable func move(_ position: inout Position, step: (Position) -> Position?, while predicate: (Caret) -> Bool) {
        while predicate(carets[position]), let next = step(position) { position = next }
    }
    
    @inlinable func moveToContent(_ position: inout Position) {
        move(&position, step: next, while: { ($0.rhs?.attribute ?? .prefix) == .prefix })
        move(&position, step: prev, while: { ($0.lhs?.attribute ?? .suffix) == .suffix })
    }
}
