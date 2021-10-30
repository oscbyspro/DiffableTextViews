//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough
import Combine
import Foundation

// MARK: - Field

#warning("Selection should NOT be momentum based.")
#warning("Or selection should not be updated while dragging.")

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
    
    // MARK: Configure: Carets
    
    #warning("...")
    @inlinable func configure(carets newValue: Carets) -> Self {
        move(to: newValue)
            .moveToAttributes()
    }
    
    @inlinable func configure(carets newValue: Snapshot) -> Self {
        configure(carets: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    #warning("...")
    @inlinable func configure(selection newValue: Range<Carets.Index>) -> Self {
        move(to: newValue)
            .moveToAttributes()
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

// MARK: - Offsets

extension Field {
    
    // MARK: Indices In Offsets
    
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
    
    // MARK: Helpers, Path
    
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

#warning("Remove...")
extension Field {
    static var mockLayout0: String {
        ">|>,>,>,<>,<>,<>,*>,*,*,<>,<>,<>,*,*,*,*,*,<>,<>,<>,<,<,<|<"
    }
    
    static var mockLayout1: String {
        ">|>,>,>,*,*,*,<>,*,*,*,<,<,<|<"
    }
    
    static var mockLayout2: String {
        "<,>" + ">,<"
    }
}

// MARK: -

extension Field {
    
    // MARK: Move To Carets
    
    @inlinable func move(to nextCarets: Carets) -> Field {
        func step(prev: Symbol, next: Symbol) -> SimilaritiesInstruction {
            if prev == next                          { return .continue      }
            else if prev.attribute.contains(.remove) { return .continueOnLHS }
            else if next.attribute.contains(.insert) { return .continueOnRHS }
            else                                     { return .done          }
        }
        
        #warning("Think about this.")
        func inspectable(symbol: Symbol) -> Bool {
            !symbol.attribute.contains(.composite(.change))
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
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: nextCarets[...])
        let nextLowerBound = position(from: carets[selection], to: nextCarets[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(nextCarets, selection: nextLowerBound ..< nextUpperBound)
    }
}

// MARK: Move To Selection

extension Field {
    
    // MARK: Main

    @inlinable func move(to nextSelection: Range<Carets.Index>) -> Field {
        update({ $0.selection = nextSelection })
    }
    
    // MARK: Looks
    
    @inlinable func look(_ start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards ? lookahead(start) : lookbehind(start)
    }

    @inlinable func lookahead(_ start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.rhs.attribute.contains(.prefix)
        }
        
        return carets[start...].firstIndex(where: predicate) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(_ start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.lhs.attribute.contains(.suffix)
        }
        
        return carets[...start].lastIndex(where: predicate) ?? carets.firstIndex
    }
}

// MARK: Move To Attributes

extension Field {
    
    // MARK: Main
    
    @inlinable func moveToAttributes() -> Field {
        func position(_ position: Carets.Index, preference: Direction) -> Carets.Index {
            let direction = directionOfAttributes(at: position)
            return look(position, direction: direction ?? preference)
        }
        
        let upperBound = position(selection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !selection.isEmpty {
            lowerBound = position(selection.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Direction Of Attributes
    
    @inlinable func directionOfAttributes(at position: Carets.Index) -> Direction? {
        let element = carets[position]
        
        func bothSidesContains(_ attribute: Attribute) -> Bool {
            element.lhs.attribute.contains(attribute) && element.rhs.attribute.contains(attribute)
        }
        
        let forwards  = bothSidesContains(.prefix)
        let backwards = bothSidesContains(.suffix)
        
        print(element.lhs.character, element.rhs.character)
        
        guard forwards != backwards else {
            return nil
        }
        
        return forwards ? .forwards : .backwards
    }
}
