//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import protocol Utilities.Transformable

// MARK: - Field

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme>: Transformable {
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Range<Carets.Index>

    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = Carets(snapshot)
        self.selection = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ carets: Carets, selection: Range<Carets.Index>) {
        self.carets = carets
        self.selection = selection
    }
    
    // MARK: Getters
    
    @inlinable var offsets: Range<Offset> {
        selection.lowerBound.offset ..< selection.upperBound.offset
    }
    
    // MARK: Look
    
    @inlinable func look(_ start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards ? lookahead(start) : lookbehind(start)
    }

    @inlinable func lookahead(_ start: Carets.Index) -> Carets.Index {
        carets[start...].firstIndex(where: \.nonlookaheadable) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(_ start: Carets.Index) -> Carets.Index {
        carets[...start].lastIndex(where: \.nonlookbehindable) ?? carets.firstIndex
    }
    
    // MARK: Update: Carets
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        transformingAccordingToCarets(newValue).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(carets newValue: Snapshot) -> Self {
        updating(carets: Carets(newValue))
    }

    // MARK: Update: Selection
    
    @inlinable func updating(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        transformingAccordingToSelection(newValue, intent: intent).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(selection newValue: Carets.Index, intent: Direction?) -> Self {
        updating(selection: newValue ..< newValue, intent: intent)
    }
    
    @inlinable func updating(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        updating(selection: indices(in: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Offset, intent: Direction?) -> Self {
        updating(selection: newValue ..< newValue, intent: intent)
    }

    // MARK: Transformations: Attribute
                    
    @inlinable func transformingAccordingToAttributes() -> Field {
        func position(_ position: Carets.Index, preference: Direction) -> Carets.Index {
            look(position, direction: carets[position].directionOfAttributes() ?? preference)
        }
        
        // --------------------------------- //
        
        return transforming({ $0.selection = map(selection, transformation: position) })
    }

    // MARK: Transformations: Selection
        
    @inlinable func transformingAccordingToSelection(_ newValue: Range<Carets.Index>, intent: Direction?) -> Field {
        func position(_ start: Carets.Index, preference: Direction) -> Carets.Index {
            if carets[start].nonlookable(direction: preference) { return start }
                        
            // --------------------------------- //
            
            let direction = intent ?? preference
            let next = look(start, direction: direction)
            
            // --------------------------------- //
            
            if direction == preference { return next }
            
            switch direction {
            case .forwards:  return next < carets.lastIndex  ? carets.index(after:  next) : next
            case .backwards: return next > carets.firstIndex ? carets.index(before: next) : next
            }
        }
        
        // --------------------------------- //

        return transforming({ $0.selection = map(newValue, transformation: position) })
    }
    
    // MARK: Transformations: Carets
            
    @inlinable func transformingAccordingToCarets(_ newValue: Carets) -> Field {
        func step(previous lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
            if lhs == rhs                               { return .continue      }
            else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
            else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
            else                                        { return .done          }
        }
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions(comparison: .instruction(step), inspection: .only(\.nonformatting))
        
        // --------------------------------- //

        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            Similarities(in: current.lazy.map(\.rhs), and: next.lazy.map(\.rhs), with: options).rhsSuffix().startIndex
        }
        
        // --------------------------------- //
        
        let upperBound = position(from: carets.suffix(from: selection.upperBound), to: newValue[...])
        let lowerBound = position(from: carets[selection],     to: newValue.prefix(upTo: upperBound))
                
        // --------------------------------- //
        
        return Field(newValue, selection: lowerBound ..< upperBound)
    }
    
    // MARK: Transformations: Helpers
    
    #warning("Make a Selection model and add this method to it, maybe.")
    @inlinable func map(_ range: Range<Carets.Index>, transformation: (Carets.Index, Direction) -> Carets.Index) -> Range<Carets.Index> {
        let upperBound = transformation(range.upperBound, .backwards)
        var lowerBound = upperBound

        if !range.isEmpty {
            lowerBound = transformation(range.lowerBound,  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Utilities: Indices
    
    @inlinable func indices(in offsets: Range<Offset>) -> Range<Carets.Index> {
        func position(_ start: Carets.Index, destination: Offset) -> Carets.Index {
            if start.offset <= destination {
                return carets.indices[start...].first(where: { index in index.offset >= destination }) ?? carets.lastIndex
            } else {
                return carets.indices[...start].last(where: { index in index.offset <= destination }) ?? carets.firstIndex
            }
        }
        
        #warning("Add to Selection model, maybe.")
        let upperBound = position(selection.upperBound, destination: offsets.upperBound)
        var lowerBound = upperBound
        
        if !offsets.isEmpty {
            lowerBound = position(selection.lowerBound, destination: offsets.lowerBound)
        }
        
        return lowerBound ..< upperBound
    }
}
