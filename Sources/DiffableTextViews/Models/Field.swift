//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import protocol Utilities.Transformable

// MARK: - Field

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme>: Transformable {
    @usableFromInline typealias Selection = DiffableTextViews.Selection<Scheme>
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>

    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Selection

    // MARK: Initializers
    
    @inlinable init() {
        self.init(snapshot: Snapshot())
    }
    
    @inlinable init(snapshot: Snapshot) {
        self.carets = Carets(snapshot: snapshot)
        self.selection = Selection(position: carets.lastIndex)
    }
    
    @inlinable init(carets: Carets, selection: Selection) {
        self.carets = carets
        self.selection = selection
    }
    
    // MARK: Utilities
    
    @inlinable func indices(at offsets: Range<Offset>) -> Range<Carets.Index> {
        let upperBound = carets.index(at: offsets.upperBound, start: selection.upperBound)
        var lowerBound = upperBound
        
        if !offsets.isEmpty {
            lowerBound = carets.index(at: offsets.lowerBound, start: selection.lowerBound)
        }
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Transformations: Carets
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        transformingAccordingToCarets(newValue).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(carets newValue: Snapshot) -> Self {
        updating(carets: Carets(snapshot: newValue))
    }

    // MARK: Transformations: Selection
    
    @inlinable func updating(selection newValue: Selection, intent: Direction?) -> Self {
        transformingAccordingToSelection(newValue, intent: intent).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        updating(selection: Selection(range: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Carets.Index, intent: Direction?) -> Self {
        updating(selection: Selection(position: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        updating(selection: Selection(range: indices(at: newValue)), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Offset, intent: Direction?) -> Self {
        updating(selection: Selection(range: indices(at: newValue ..< newValue)), intent: intent)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func look(_ start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards ? lookahead(start) : lookbehind(start)
    }

    @inlinable func lookahead(_ start: Carets.Index) -> Carets.Index {
        carets[start...].firstIndex(where: \.nonlookaheadable) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(_ start: Carets.Index) -> Carets.Index {
        carets[...start].lastIndex(where: \.nonlookbehindable) ?? carets.firstIndex
    }
    
    // MARK: Transformations: * Attributes *
                    
    @inlinable func transformingAccordingToAttributes() -> Field {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            look(start, direction: carets[start].directionOfAttributes() ?? preference)
        }

        // --------------------------------- //

        return transforming({ $0.selection = selection.preferential(position) })
    }

    // MARK: Transformations: * Selection *
        
    @inlinable func transformingAccordingToSelection(_ newValue: Selection, intent: Direction?) -> Field {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
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

        return transforming({ $0.selection = newValue.preferential(position) })
    }
    
    // MARK: Transformations: * Carets *
            
    @inlinable func transformingAccordingToCarets(_ newValue: Carets) -> Field {
        func position(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            _Field.position(current: current.lazy.map(\.rhs), next: next.lazy.map(\.rhs))
        }
        
        // --------------------------------- //
        
        let upperBound = position(current: carets.suffix(from: selection.upperBound),   next: newValue[...])
        let lowerBound = position(current: carets[selection.range], next: newValue.prefix(upTo: upperBound))
                
        // --------------------------------- //
        
        return Field(carets: newValue, selection: Selection(range: lowerBound ..< upperBound))
    }
}

// MARK: - Field: Constants

@usableFromInline enum _Field {
    
    // MARK: Similarities: Position
    
    @inlinable static func position<Current: BidirectionalCollection, Next: BidirectionalCollection>(current: Current, next: Next) -> Next.Index where Current.Element == Symbol, Next.Element == Symbol {
        Similarities(lhs: current, rhs: next, options: options).rhsSuffix().startIndex
    }
    
    // MARK: Similarities: Options
    
    @usableFromInline static let options: SimilaritiesOptions = {
        .init(comparison: .instruction(step), inspection: .only(\.nonformatting))
    }()
    
    // MARK: Similarities: Helpers
    
    @inlinable static func step(current lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
        if lhs == rhs                               { return .continue      }
        else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
        else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
        else                                        { return .done          }
    }
}
