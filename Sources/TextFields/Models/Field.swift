//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

// MARK: - Field

@usableFromInline struct Field<Layout: TextFields.Layout> {
    @usableFromInline typealias Carets = TextFields.Carets<Layout>
    @usableFromInline typealias Offset = TextFields.Offset<Layout>
    
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
    
    @inlinable func configure(selection newValue: Carets.Index) -> Self {
        configure(selection: newValue ..< newValue)
    }
    
    // MARK: Configure: Offsets
    
    @inlinable func configure(selection newValue: Range<Offset>) -> Self {
        configure(selection: indices(in: newValue))
    }
    
    @inlinable func configure(selection newValue: Offset) -> Self {
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

// MARK: - Offsets

extension Field {
    
    // MARK: Indices: In Offsets
    
    @inlinable func indices(in offsets: Range<Offset>) -> Range<Carets.Index> {
        var indices = [Carets.Index]()
        indices.reserveCapacity(5)
        indices.append(contentsOf: [carets.firstIndex,         carets.endIndex])
        indices.append(contentsOf: [selection.lowerBound, selection.upperBound])
        
        // --------------------------------- //
    
        func index(at offset: Offset) -> Carets.Index {
            let shortestPath = indices.map({ Path($0, offset: offset) }).min()!
            return carets.index(start: shortestPath.origin, offset: shortestPath.offset)
        }
        
        // --------------------------------- //
        
        let lowerBound = index(at: offsets.lowerBound)
        indices.append(lowerBound)
        let upperBound = index(at: offsets.upperBound)
                        
        // --------------------------------- //
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Path
    
    @usableFromInline struct Path: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let origin: Carets.Index
        @usableFromInline let offset: Offset
        
        // MARK: Initializers
        
        @inlinable init(_ origin: Carets.Index, offset: Offset) {
            self.origin = origin
            self.offset = offset
        }
        
        // MARK: Comparisons
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            abs(lhs.offset.distance) < abs(rhs.offset.distance)
        }
    }
}
