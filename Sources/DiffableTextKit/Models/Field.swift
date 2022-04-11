//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Field
//*============================================================================*

/// A model describing a snapshot's layout and a selection in it.
///
/// - Autocorrects selection on layout changes.
/// - Autocorrects selection on selection changes.
///
public struct Field<Scheme: DiffableTextKit.Scheme> {
    public typealias Layout = DiffableTextKit.Layout<Scheme>
    public typealias Index = DiffableTextKit.Layout<Scheme>.Index
    public typealias Position = DiffableTextKit.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var layout: Layout
    @usableFromInline var selection: Range<Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ layout: Layout = Layout()) {
        self.layout = layout; self.selection = Range.init(
        uncheckedBounds: (layout.endIndex, layout.endIndex))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func indices(at positions: Range<Position>) -> Range<Index> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = layout.index(at: positions.upperBound, from: selection.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !positions.isEmpty {
            lowerBound = layout.index(at: positions.lowerBound, from: selection.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Layout
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(layout: Layout) {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(next: layout,
        prev: self.layout[selection.upperBound...]).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = Mismatches.prefix(next: layout,
            prev: self.layout[..<selection.lowerBound]).next
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.update(selection: lowerBound ..< upperBound)
    }

    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Boolean As Momentum
        //=--------------------------------------=
        let momentum = momentum ? Momentum(self.selection, to: selection) : .none
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Index>, momentum: Momentum = .none) {
        //=--------------------------------------=
        // MARK: Accept Max Selection
        //=--------------------------------------=
        if selection == layout.range {
            self.selection = selection
            return
        }
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = layout.caret(from: selection.upperBound,
        /**/towards: momentum.upperBound, preferring: .backwards)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = layout.caret(from: selection.lowerBound,
            towards: momentum.lowerBound, preferring:  .forwards)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = lowerBound ..< upperBound
    }
}
