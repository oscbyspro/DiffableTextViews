//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Field
//*============================================================================*

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Layout = DiffableTextViews.Layout<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var layout: Layout
    @usableFromInline var selection: Range<Layout.Index>

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
// MARK: + Indices
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Destination
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        layout.indices(start: selection, destination: destination)
    }
    
    @inlinable func indices(at destination: NSRange) -> Range<Layout.Index> {
        indices(at: Position(destination.lowerBound) ..< Position(destination.upperBound))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Update
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Selection - Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(past: self.layout[selection.upperBound...], next: layout).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Selection - Double
        //=--------------------------------------=
        if !self.selection.isEmpty {
            lowerBound = Mismatches.prefix(past: self.layout[..<selection.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.selection = lowerBound ..< upperBound
        self.autocorrect(intent: .none)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Update
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        //=--------------------------------------=
        // MARK: Parse Position As Index
        //=--------------------------------------=
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Momentum As Intent
        //=--------------------------------------=
        let intent = momentum ? .momentum(from: self.selection, to: selection) : Intent.none
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = selection
        self.autocorrect(intent: intent)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Autocorrect
//=----------------------------------------------------------------------------=

extension Field {
        
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrect(intent: Intent) {
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if selection == layout.range { return }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.selection = layout.preferred(selection, intent: intent)
    }
}
