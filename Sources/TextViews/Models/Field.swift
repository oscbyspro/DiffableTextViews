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
#warning("A spacer should actually be: [.prefix, .suffix], or rather: [.lookahead, .lookbehind]")

#warning("Prefix can be viewed as a lookahead.")
#warning("Suffix can be viewed as a lookbehind.")
#warning("A look contains: lowerBound(?), start, upperBound(?). A caret may choose between based on preference, momentum, etc.")

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
//            .moveToAttributes()
    }
    
    @inlinable func configure(carets newValue: Snapshot) -> Self {
        configure(carets: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    #warning("...")
    @inlinable func configure(selection newValue: Range<Carets.Index>) -> Self {
        move(to: newValue)
//            .moveToAttributes()
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
    
    // MARK: Components: Direction
    
    @usableFromInline enum Direction {
        case forwards
        case backwards
        
        // MARK: Initializers
        
        @inlinable init?(_ start: Carets.Index, to end: Carets.Index) {
            if start < end { self = .forwards }
            else if start > end { self = .backwards }
            else { return nil }
        }
        
        // MARK: Utilities
        
        @inlinable var opposite: Direction {
            switch self {
            case .forwards:  return .backwards
            case .backwards: return .forwards
            }
        }
        
        @inlinable var step: Walkthrough<Carets>.Step {
            switch self {
            case .forwards:  return .forwards
            case .backwards: return .backwards
            }
        }
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
            if prev == next { return .continue }
            else if prev.attribute.contains(.removable)  { return .continueOnLHS }
            else if next.attribute.contains(.insertable) { return .continueOnRHS }
            else { return .done }
        }
        
        #warning("Think about this.")
        func inspectable(symbol: Symbol) -> Bool {
            !symbol.attribute.contains(.theme(.nondiffable))
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

}

#warning("WIP")

extension Field {
    
    #warning("Think about this.")
    @usableFromInline struct Peak {
        let lowerBound: Carets.Index?
        let upperBound: Carets.Index?
    }
    
    @inlinable func lookahead(start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.rhs.attribute.contains(.lookahead)
        }
        
        return carets[start...].firstIndex(where: predicate) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.lhs.attribute.contains(.lookbehind)
        }
        
        return carets[...start].lastIndex(where: predicate) ?? carets.firstIndex
    }
    
    
    @inlinable func move(to nextSelection: Range<Carets.Index>) -> Field {
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Direction) -> Carets.Index {
            let next = positionIn(nextSelection)
            let direction = Direction(positionIn(selection), to: next) ?? preference
            
            // --------------------------------- //
          
//            if predicateIsContent(preference)(carets[next]) {
//                print(0)
//                return next
//            }
//
//            // --------------------------------- //
//
//            let momentum = Direction(current, to: next)
//            let direction = momentum ?? preference
//
//            // --------------------------------- //
//
//            if let breakpoint = contentOrStop(from: next, direction: direction) {
//                print(1)
//                return correct(breakpoint, direction: direction, preference: preference)
//            }
//
//            // --------------------------------- //
//
//            print(3)
//            return current
            
            #error("...")
        }
                
        #error("...")
        
//        let upperBound = position(\.upperBound, preference: .backwards)
//        var lowerBound = upperBound
//
//        if !nextSelection.isEmpty {
//            lowerBound = position(\.lowerBound, preference:  .forwards)
//            lowerBound = min(lowerBound, upperBound)
//        }
//
//        return update({ $0.selection = lowerBound ..< upperBound })
    }
}

#warning("WIP")

extension Field {
        
    // --------------------------------- //
    // --------------------------------- //
    // --------------------------------- //

        
//    @inlinable func predicateIsContent(_ direction: Direction) -> (Carets.Element) -> Bool {
//        func forwards(element: Carets.Element) -> Bool {
//            !element.rhs.attribute.contains(.format)
//        }
//
//        func backwards(element: Carets.Element) -> Bool {
//            !element.lhs.attribute.contains(.format)
//        }
//
//        return direction == .forwards ? forwards : backwards
//    }
//
//    @inlinable func predicateIsStop(_ direction: Direction) -> (Carets.Element) -> Bool {
//        func forwards(element: Carets.Element) -> Bool {
//            element.rhs.attribute.contains(.suffix)
//        }
//
//        func backwards(element: Carets.Element) -> Bool {
//            element.lhs.attribute.contains(.prefix)
//        }
//
//        return direction == .forwards ? forwards : backwards
//    }
//
//    @inlinable func predicateIsLessThanLimit(_ direction: Direction) -> (Carets.Index) -> Bool {
//        func forwards(position: Carets.Index) -> Bool {
//            position < carets.lastIndex
//        }
//
//        func backwards(position: Carets.Index) -> Bool {
//            position > carets.firstIndex
//        }
//
//        return direction == .forwards ? forwards : backwards
//    }
//
//    #warning("Can be foreunwrapped so long as carets starts with carets min.contains(.prefix), max.contains(.suffix)")
//    @inlinable func contentOrStop(from position: Carets.Index, direction: Direction) -> Carets.Index? {
//        let isContent = predicateIsContent(direction)
//        let isStop = predicateIsStop(direction)
//
//        func predicate(element: Carets.Element) -> Bool {
//            isContent(element) || isStop(element)
//        }
//
//        switch direction {
//        case .forwards: return carets[position...].firstIndex(where: predicate)
//        case .backwards: return carets[...position].lastIndex(where: predicate)
//        }
//    }
//
//    @inlinable func correct(_ position: Carets.Index, direction: Direction, preference: Direction) -> Carets.Index {
//        guard preference != direction else { return position }
//        guard predicateIsContent(direction)(carets[position]) else { return position }
//        guard predicateIsLessThanLimit(direction)(position) else { return position }
//
//        switch direction {
//        case .forwards:  return carets.index(after:  position)
//        case .backwards: return carets.index(before: position)
//        }
//    }
//
//    #warning("Use simple logic then use post process shared with moveTo(nextCarets).")
//    @inlinable func __move(to nextSelection: Range<Carets.Index>) -> Field {
//        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Direction) -> Carets.Index {
//            let current = positionIn(selection)
//            let next = positionIn(nextSelection)
//
//            // --------------------------------- //
//
//            if predicateIsContent(preference)(carets[next]) {
//                print(0)
//                return next
//            }
//
//            // --------------------------------- //
//
//            let momentum = Direction(current, to: next)
//            let direction = momentum ?? preference
//
//            // --------------------------------- //
//
//            if let breakpoint = contentOrStop(from: next, direction: direction) {
//                print(1)
//                return correct(breakpoint, direction: direction, preference: preference)
//            }
//
//            // --------------------------------- //
//
//            print(3)
//            return current
//        }
//
//        let upperBound = position(\.upperBound, preference: .backwards)
//        var lowerBound = upperBound
//
//        if !nextSelection.isEmpty {
//            lowerBound = position(\.lowerBound, preference:  .forwards)
//            lowerBound = min(lowerBound, upperBound)
//        }
//
//        return update({ $0.selection = lowerBound ..< upperBound })
//    }
}
