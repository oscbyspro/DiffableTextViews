//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

struct Selection {
    typealias Carets = OBETextFields.Carets<Format>
    
    // MARK: Properties: Stored
    
    let carets: Carets
    var bounds: Range<Carets.Index>
    
    // MARK: Properties: Calculated
    
    @inlinable var offsets: Range<Int> {
        bounds.map({ $0.rhs?.offset ?? 0 })        
    }
    
    // MARK: Initializers
    
    @inlinable init(_ carets: Carets) {
        self.carets = carets
        self.bounds = carets.lastIndex() ..< carets.lastIndex()
    }
    
    @inlinable init(_ carets: Carets, bounds: Range<Carets.Index>) {
        self.carets = carets
        self.bounds = bounds
    }
    
    // MARK: Transformations
    
    @inlinable func moved(to nextCarets: Carets) -> Self {
        func relevant(element: Carets.Element) -> Bool {
            element.rhs?.attribute == .content
        }
        
        func comparison(lhs: Carets.Element, rhs: Carets.Element) -> Bool {
            lhs.rhs?.character == rhs.rhs?.character
        }
        
        func index(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            next.suffix(alsoIn: current, options: .inspect(relevant, overshoot: true)).startIndex
        }
        
        let nextUpperBound = index(current: carets[...bounds.upperBound], next: nextCarets[...])
        let nextLowerBound = index(current: carets[bounds], next: nextCarets[...nextUpperBound])
        
        return Selection(nextCarets, bounds: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func moved(to nextBounds: Range<Carets.Index>) -> Self {
        var nextLowerBound = nextBounds.lowerBound
        var nextUpperBound = nextBounds.upperBound
        
        #error("This method should keep it carets content.")
        
        return Selection(carets, bounds: nextLowerBound ..< nextUpperBound)
    }
}
