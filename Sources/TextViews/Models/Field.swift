//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

// MARK: - Field

@usableFromInline struct Field<Layout: TextViews.Layout> {
    @usableFromInline typealias Carets = TextViews.Carets<Layout>
    @usableFromInline typealias Offset = TextViews.Offset<Layout>
    
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
        func step(prev: Symbol, next: Symbol) -> SimilaritiesInstruction {
            if      prev == next                     { return .continue      }
            else if prev.attribute.contains(.remove) { return .continueOnLHS }
            else if next.attribute.contains(.insert) { return .continueOnRHS }
            else                                     { return .done          }
        }
        
        func inspectable(symbol: Symbol) -> Bool {
            !symbol.attribute.contains(.thematic(.nondifferentiable))
        }
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .compare(.instruction(step))
            .inspect(.only(inspectable))

        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            Similarities(in: current.lazy.map(\.rhs), and: next.lazy.map(\.rhs), with: options).rhsSuffix().startIndex
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
}

// MARK: Move: To Content

extension Field {
    
    // MARK: Transformation

    @inlinable func moveToContent() -> Field {
        func position(_ position: Carets.Index) -> Carets.Index {
            func move(_ direction: Walkthrough<Carets>.Step, when side: Side, contains attribute: Attribute) -> Carets.Index? {
                guard side.current(carets[position]).attribute.contains(attribute) else { return nil }

                func predicate(element: Carets.Element) -> Bool {
                    !side.inverse(element).attribute.contains(attribute)
                }
                
                return carets.firstIndex(in: .stride(start: .closed(position), step: direction), where: predicate)
            }
            
            if let next = move(.backwards, when: .rhs, contains: .suffix) { return next }
            if let next = move(.forwards,  when: .lhs, contains: .prefix) { return next }
                        
            return position
        }
        
        // --------------------------------- //
        
        let lowerBound = position(selection.lowerBound)
        let upperBound = position(selection.upperBound)
        
        // --------------------------------- //

        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Helpers
    
    @usableFromInline struct Side {
        
        // MARK: Properties
        
        @usableFromInline let current: (Carets.Element) -> Symbol
        @usableFromInline let inverse: (Carets.Element) -> Symbol
        
        // MARK: Initializers
        
        @inlinable init(current: @escaping (Carets.Element) -> Symbol, inverse: @escaping (Carets.Element) -> Symbol) {
            self.current = current
            self.inverse = inverse
        }
        
        // MARK: Initializers, Static
        
        @inlinable static var lhs: Self {
            .init(current: \.lhs, inverse: \.rhs)
        }
        
        @inlinable static var rhs: Self {
            .init(current: \.rhs, inverse: \.lhs)
        }
    }
}

// MARK: Move: To

extension Field {
    
    // MARK: Transformation
    
    @inlinable func move(to newValue: Range<Carets.Index>) -> Field {
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Walkthrough<Carets>.Step, symbol: @escaping (Carets.Element) -> Symbol) -> Carets.Index {
            let position = positionIn(newValue)
            let direction = momentum(from: positionIn(selection), to: position) ?? preference
            let limit: Attribute = direction.forwards ? .prefix : .suffix
                        
            func predicate(element: Carets.Element) -> Bool {
                !symbol(element).attribute.contains(limit)
            }
            
            return carets.firstIndex(in: .stride(start: .closed(position), step: direction), where: predicate) ?? position
        }
        
        // --------------------------------- //
                
        let upperBound = position(\.upperBound, preference: .backwards, symbol: \.lhs)
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, symbol: \.rhs)
        }
        
        // --------------------------------- //
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Heleprs
    
    @inlinable func momentum(from first: Carets.Index, to second: Carets.Index) -> Walkthrough<Carets>.Step? {
        if      first < second { return  .forwards }
        else if first > second { return .backwards }
        else                   { return      .none }
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
