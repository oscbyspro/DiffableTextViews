//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Foundation.NSRange
import struct Sequences.Walkthrough

// MARK: - Field

@usableFromInline struct Field<Layout: TextFields.Layout> {
    @usableFromInline typealias Carets = TextFields.Carets<Layout>
    @usableFromInline typealias Position = TextFields.Position<Layout>
    
    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Range<Carets.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = Carets(snapshot)
        self.selection = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ field: Carets, selection: Range<Carets.Index>) {
        self.carets = field
        self.selection = selection
    }
    
    // MARK: Translate: To Carets
    
    @inlinable func translate(to newValue: Carets) -> Self {
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .inspect(.only(\.content))
            .compare(.equatable(\.character))
        
        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            next.lazy.map(\.rhs).suffix(alsoIn: current.lazy.map(\.rhs), options: options).startIndex
        }
        
        // --------------------------------- //
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: carets[selection], to: newValue[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(newValue, selection: nextLowerBound ..< nextUpperBound).moveToContent()
    }
    
    @inlinable func translate(to newValue: Snapshot) -> Self {
        translate(to: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    @inlinable func configure(selection newValue: Range<Carets.Index>) -> Self {
        move(to: newValue).moveToContent()
    }
    
    @inlinable func configure(selection newValue: Range<Position>) -> Self {
       configure(selection: indices(in: newValue))
    }
    
    // MARK: Configure: Position
    
    @inlinable func configure(selection newValue: Carets.Index) -> Self {
        configure(selection: newValue ..< newValue)
    }
    
    // MARK: Helpers: Update
    
    @inlinable func update(_ transform: (inout Field) -> Void) -> Field {
        var copy = self; transform(&copy); return copy
    }

    // MARK: Move: To Content
    
    @inlinable func moveToContent() -> Field {
        func position(_ position: Carets.Index) -> Carets.Index {
            var position = position
            
            func condition() -> Bool {
                let element = carets[position]; return element.lhs.noncontent && element.rhs.noncontent
            }
                        
            func move(_ direction: Walkthrough<Carets>.Step, towards predicate: (Carets.Element) -> Bool) {
                position = carets.firstIndex(in: .stride(start: .closed(position), step: direction), where: predicate) ?? position
            }
            
            if condition() {
                move(.backwards, towards: { $0.lhs.content || $0.lhs.prefix })
            }
            
            if condition() {
                move(.forwards,  towards: { $0.rhs.content || $0.rhs.suffix })
            }
            
            return position
        }
        
        // --------------------------------- //
        
        let lowerBound = position(selection.lowerBound)
        let upperBound = position(selection.upperBound)
        
        // --------------------------------- //

        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Move: To, Jumps Over Spacers
    
    @inlinable func move(to newValue: Range<Carets.Index>) -> Field {
        func momentum(from first: Carets.Index, to second: Carets.Index) -> Walkthrough<Carets>.Step? {
            if      first < second { return  .forwards }
            else if first > second { return .backwards }
            else                   { return      .none }
        }
        
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Walkthrough<Carets>.Step, where predicate: (Carets.Element) -> Bool) -> Carets.Index {
            let position = positionIn(newValue)
            let momentum = momentum(from: positionIn(selection), to: position) ?? preference
    
            return carets.firstIndex(in: .stride(start: .closed(position), step: momentum), where: predicate) ?? position
        }
        
        // --------------------------------- //
        
        let upperBound = position(\.upperBound, preference: .backwards, where: \.lhs.nonspacer)
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, where: \.rhs.nonspacer)
        }
        
        // --------------------------------- //
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
}

// MARK: - Indices, Shortest Path

extension Field {
    
    // MARK: Indices: In Position Range
    
    @inlinable func indices(in range: Range<Position>) -> Range<Carets.Index> {
        
        // --------------------------------- //
        
        var indices = [Carets.Index]()
        indices.reserveCapacity(5)
        indices += [carets.firstIndex, carets.endIndex, selection.lowerBound, selection.upperBound]
        
        // --------------------------------- //
    
        func index(at position: Position, append: Bool) -> Carets.Index {
            let shortestPath = indices.map({ Path($0, distance: position) }).min()!
            let index = carets.index(shortestPath.start, offsetBy: shortestPath.distance)
                        
            if append {
                indices.append(index)
            }
            
            return index
        }
        
        // --------------------------------- //
        
        let lowerBound = index(at: range.lowerBound, append: true)
        let upperBound = index(at: range.upperBound, append: false)
                        
        // --------------------------------- //
        
        return lowerBound ..< upperBound
        
        // --------------------------------- //
    }
    
    // MARK: Path
    
    @usableFromInline struct Path: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let start: Carets.Index
        @usableFromInline let distance: Position
        
        // MARK: Initializers
        
        @inlinable init(_ start: Carets.Index, distance: Position) {
            self.start = start
            self.distance = distance
        }
        
        // MARK: Comparisons
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            abs(lhs.distance.offset) < abs(rhs.distance.offset)
        }
    }
}
