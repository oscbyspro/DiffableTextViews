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

#warning("Eureka!")
#warning("Spacer == [.prefix, .suffix]")
#warning("func move(to|nextSelection) should NOT care about [.format], as [] and [.format] should behave the same way.")

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

// MARK: - Move To Carets

extension Field {
    
    #warning("This works OK.")
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
        
        #warning("...")
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .compare(.instruction(step))
            .inspect(.only(inspectable))

        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            Similarities(in: current.lazy.map(\.rhs), and: next.lazy.map(\.rhs), with: options).rhsSuffix().startIndex
        }
        
        // --------------------------------- //
        
        #warning("Needs to be corrected forwards.")
        let nextUpperBound = position(from: carets[selection.upperBound...], to: nextCarets[...])
        let nextLowerBound = position(from: carets[selection], to: nextCarets[..<nextUpperBound])
                
        // --------------------------------- //
        
        #warning("Should be post-processed to follow attributes.")
        return Field(nextCarets, selection: nextLowerBound ..< nextUpperBound)
    }
}

// MARK: - Move To Selection

#warning("WIP")

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

#warning("WIP")

extension Field {
    
    @inlinable func directionsOfAttributes(at position: Carets.Index) -> (forwards: Bool, backwards: Bool) {
        let element = carets[position]
        
        func bothSidesContains(_ attribute: Attribute) -> Bool {
            element.lhs.attribute.contains(attribute) && element.rhs.attribute.contains(attribute)
        }
        
        let forwards  = bothSidesContains(.prefix)
        let backwards = bothSidesContains(.suffix)
        
        return (forwards, backwards)
    }
    
    #warning("May or may not work.")
    @inlinable func moveToAttributes() -> Field {
        func position(_ position: Carets.Index, preference: Direction) -> Carets.Index {
            let direction = directionsOfAttributes(at: position)
            
            switch (direction.forwards, direction.backwards) {
            case (false, false): return position
            case (true,  false): return lookahead(start: position)
            case (false,  true): return lookbehind(start: position)
            case (true,   true): return look(preference, start: position)
            }
        }
        
        let upperBound = position(selection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !selection.isEmpty {
            lowerBound = position(selection.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
}

#warning("WIP")

extension Field {
    
    @inlinable func subpredicate(points direction: Direction) -> (Symbol) -> Bool {
        func forwards(symbol: Symbol) -> Bool {
            symbol.attribute.contains(.prefix)
        }
        
        func backwards(symbol: Symbol) -> Bool {
            symbol.attribute.contains(.suffix)
        }
        
        return direction == .forwards ? forwards : backwards
    }
    
    @inlinable func predicate(side direction: Direction, where subpredicate: @escaping (Symbol) -> Bool) -> (Carets.Element) -> Bool {
        func forwards(element:  Carets.Element) -> Bool {
            subpredicate(element.rhs)
        }
        
        func backwards(element: Carets.Element) -> Bool {
            subpredicate(element.lhs)
        }

        return direction == .forwards ? forwards : backwards
    }
    
    @inlinable func lookahead(start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.rhs.attribute.contains(.prefix)
        }
        
        return carets[start...].firstIndex(where: predicate) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.lhs.attribute.contains(.suffix)
        }
        
        return carets[...start].lastIndex(where: predicate) ?? carets.firstIndex
    }
    
    @inlinable func look(_ direction: Direction, start: Carets.Index) -> Carets.Index {
        switch direction {
        case .forwards: return lookahead(start: start)
        case .backwards: return lookbehind(start: start)
        }
    }
    
    @inlinable func move(to nextSelection: Range<Carets.Index>) -> Field {
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Direction) -> Carets.Index {
            let start = positionIn(nextSelection)
            let direction = Direction(from: positionIn(selection), to: start) ?? preference
            
            // --------------------------------- //
            
            func validation() -> Carets.Index? {
                !predicate(side: preference, where: subpredicate(points: direction))(carets[start]) ? start : nil
            }
            
            func lookaround() -> Carets.Index {
                direction == .forwards ? lookahead(start: start) : lookbehind(start: start)
            }
                        
            func correct(_ position: Carets.Index) -> Carets.Index {
                guard direction != preference else { return position }
                
                switch direction {
                case .forwards:  return position < carets.lastIndex  ? carets.index(after:  position) : position
                case .backwards: return position > carets.firstIndex ? carets.index(before: position) : position
                }
            }
            
            // --------------------------------- //
            
            return validation() ?? correct(lookaround())
        }
        
        let upperBound = position(\.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !nextSelection.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }

        return update({ $0.selection = lowerBound ..< upperBound })
    }
}
