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

/// A model describing a snapshot's layout and a selection in it.
public struct Field<Scheme: DiffableTextKit.Scheme> {
    public typealias Layout = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var layout: Layout
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

    @inlinable public var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable public var characters: String {
        layout.snapshot.characters
    }
    
    @inlinable public var positions: Range<Position> {
        selection.lowerBound.position ..< selection.upperBound.position
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        layout.indices(start: selection, destination: destination)
    }
    
    @inlinable public func indices(at destination: NSRange) -> Range<Layout.Index> {
        indices(at: Position(destination.lowerBound) ..< Position(destination.upperBound))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Boolean As Momentum
        //=--------------------------------------=
        let momentum = momentum ? Momentum(self.selection, to: selection) : Momentum()
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Layout.Index>, momentum: Momentum = Momentum()) {
        self.selection = selection
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if selection == layout.range { return }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        self.selection = layout.preferred(selection, momentum: momentum)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(past: self.layout[selection.upperBound...], next: layout).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = Mismatches.prefix(past: self.layout[..<selection.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.update(selection: lowerBound ..< upperBound)
    }
}
