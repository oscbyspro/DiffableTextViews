//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-27.
//

import struct Foundation.NSRange

//*============================================================================*
// MARK: * State
//*============================================================================*

/// A text layout and a selection in it.
///
/// It controls how the selection is updated when various parameters change.
///
@usableFromInline final class State<Scheme: DiffableTextViews.Scheme, Value: Equatable> {
    @usableFromInline typealias Layout = DiffableTextViews.Layout<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value!
    @usableFromInline var selection: Range<Layout.Index>
    @usableFromInline private(set) var layout: Layout

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.layout = Layout()
        self.selection = layout.range
    }
    
    @inlinable init(layout: Layout, selection: Range<Layout.Index>) {
        self.layout = layout
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable var characters: String {
        layout.snapshot.characters
    }
    
    @inlinable var positions: Range<Position> {
        selection.lowerBound.position ..< selection.upperBound.position
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Calculate
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        layout.indices(start: selection, destination: destination)
    }
    
    @inlinable func indices(at destination: NSRange) -> Range<Layout.Index> {
        indices(at: Position(destination.lowerBound) ..< Position(destination.upperBound))
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Update
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Selection - Single
        //=--------------------------------------=
        let upperBound = Changes  .end(past: self.layout[self.selection.upperBound...], next: layout).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Selection - Double
        //=--------------------------------------=
        if !self.selection.isEmpty {
            lowerBound = Changes.start(past: self.layout[..<self.selection.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.selection = lowerBound ..< upperBound
        self.autocorrect(intent: (nil, nil))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot / Value
    //=------------------------------------------------------------------------=
    
    @inlinable func update(output: Output<Value>) {
        self.value = output.value
        self.update(snapshot: output.snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Update
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func update(selection: Range<Position>, momentum: Bool) {
        //=--------------------------------------=
        // MARK: Parse Position As Index
        //=--------------------------------------=
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Momentum As Intent
        //=--------------------------------------=
        let intent = !momentum ? (nil, nil) : (
        Direction(start: self.selection.lowerBound, end: selection.lowerBound),
        Direction(start: self.selection.upperBound, end: selection.upperBound))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = selection
        self.autocorrect(intent: intent)
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Autocorrect
//=----------------------------------------------------------------------------=

extension State {
        
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(intent: (lower: Direction?, upper: Direction?)) {
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if selection == layout.range { return }
        //=--------------------------------------=
        // MARK: Selection - Single
        //=--------------------------------------=
        let upperBound = layout.preferredIndex(start: selection.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Selection - Double
        //=--------------------------------------=
        if !selection.isEmpty, upperBound != layout.startIndex {
            lowerBound = layout.preferredIndex(start: selection.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = lowerBound ..< upperBound
    }
}

