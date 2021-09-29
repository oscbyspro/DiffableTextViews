//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

#warning("Give updater methods specialized parameter signatures.")
@usableFromInline struct Selection {
    @usableFromInline typealias Caret = Carets.Element
    @usableFromInline typealias Position = Carets.Index
    
    // MARK: Storage
    
    @usableFromInline let carets: Carets
    @usableFromInline var range: Range<Position>
    
    // MARK: Getters
    
    @inlinable var offsets: Range<Int> {
        range.lowerBound.offset ..< range.upperBound.offset
    }
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        let carets = snapshot.carets
        let position = carets.lastIndex
        
        self.carets = carets
        self.range = position ..< position
    }
    
    @inlinable init(_ carets: Carets, range: Range<Position>) {
        self.carets = carets
        self.range = range
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
        func relevant(element: Caret) -> Bool {
            element.rhs?.attribute == .content
        }
        
        func equivalent(lhs: Caret, rhs: Caret) -> Bool {
            rhs.rhs?.character == lhs.rhs?.character
        }
        
        let options = SimilaritiesOptions<Caret>
            .equate(equivalent)
            .evaluate(only: relevant)
            .overshoot()

        func position(current: Carets.SubSequence, next: Carets.SubSequence) -> Position {
            next.suffix(alsoIn: current, options: options).startIndex
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
    
    @inlinable func updating(offsets newValue: Range<Int>) -> Self {
        var indices = Array<Carets.Index>(capacity: 5)
        indices.append(contentsOf: [carets.firstIndex, carets.lastIndex])
        indices.append(contentsOf: [range.lowerBound, range.upperBound])
        
        #warning("Maybe make into an algorithm.")
        func position(at offset: Int, append: Bool) -> Position {
            #warning("Make something like this in the UITextField extension.")
            let distances = indices.map({( index: $0, distance: offset - $0.offset )})
            let shortest = distances.min(by: { abs($0.distance) < abs($1.distance) })!
            let destination = carets.index(shortest.index, offsetBy: shortest.distance)
            
            if append {
                indices.append(destination)
            }
            
            return destination
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
