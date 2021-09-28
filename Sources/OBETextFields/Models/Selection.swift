//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

@usableFromInline struct Selection {
    @usableFromInline let carets: Carets
    @usableFromInline var bounds: Range<Carets.Index>
    
    // MARK: Utilities
    
    @inlinable var offsets: Range<Int> {
        bounds.lowerBound.offset ..< bounds.upperBound.offset
    }
    
    // MARK: Initializers
    
    @inlinable init(_ carets: Carets) {
        self.carets = carets
        self.bounds = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ carets: Carets, bounds: Range<Carets.Index>) {
        self.carets = carets
        self.bounds = bounds
    }

    // MARK: Update: Carets
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        func relevant(element: Carets.Element) -> Bool {
            element.rhs?.attribute == .content
        }
        
        func comparison(lhs: Carets.Element, rhs: Carets.Element) -> Bool {
            lhs.rhs?.character == rhs.rhs?.character
        }
        
        func index(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            next.suffix(alsoIn: current, options: .inspect(relevant, overshoot: true)).startIndex
        }
        
        let nextUpperBound = index(current: carets[...bounds.upperBound], next: newValue[...])
        let nextLowerBound = index(current: carets[bounds], next: newValue[...nextUpperBound])
        
        return Selection(newValue, bounds: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func updating(snapshot newValue: Snapshot) -> Self {
        updating(carets: newValue.carets)
    }

    // MARK: Update: Bounds
    
    @inlinable func updating(bounds newValue: Range<Carets.Index>) -> Self {
        var nextLowerBound = newValue.lowerBound
        var nextUpperBound = newValue.upperBound
        
        moveToContent(&nextLowerBound)
        moveToContent(&nextUpperBound)
                
        return Selection(carets, bounds: nextLowerBound ..< nextUpperBound)
    }
        
    @inlinable func updating(bounds newValue: Range<Snapshot.Index>) -> Self {
        let lowerBound = carets.index(rhs: newValue.lowerBound)
        let upperBound = carets.index(rhs: newValue.upperBound)
        
        return updating(bounds: lowerBound ..< upperBound)
    }
    
    @inlinable func updating(bounds newValue: Range<Int>) -> Self {
        func bound(at offset: Int) -> Carets.Index {
            [carets.firstIndex, carets.lastIndex, bounds.lowerBound, bounds.upperBound]
                .map { (start: $0, distance: $0.offset - offset) }
                .min { $0.distance.magnitude < $1.distance.magnitude }!
                |>>> { carets.index($0.start, offsetBy: $0.distance) }
        }
        
        let lowerBound = bound(at: newValue.lowerBound)
        let upperBound = bound(at: newValue.upperBound)
        
        return updating(bounds: lowerBound ..< upperBound)
    }
        
    @inlinable func updating(location: Snapshot.Index) -> Self {
        updating(bounds: location ..< location)
    }

    // MARK: Update: Bounds - Helpers
    
    @inlinable func next(_ index: Carets.Index) -> Carets.Index? {
        index < carets.lastIndex ? carets.index(after: index) : nil
    }
    
    @inlinable func prev(_ index: Carets.Index) -> Carets.Index? {
        index > carets.firstIndex ? carets.index(before: index) : nil
    }
    
    @inlinable func move(_ index: inout Carets.Index, step: (Carets.Index) -> Carets.Index?, while predicate: (Carets.Element) -> Bool) {
        while predicate(carets[index]), let next = step(index) { index = next }
    }
    
    @inlinable func moveToContent(_ index: inout Carets.Index) {
        move(&index, step: next, while: { ($0.rhs?.attribute ?? .prefix) == .prefix })
        move(&index, step: prev, while: { ($0.lhs?.attribute ?? .suffix) == .suffix })
    }
}
