//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*===========================================================================

/// A model used to collect upstream and downstream values.
public struct Remote<Style: DiffableTextStyle> {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    public var value: Value
    public var focus: Focus

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ style: Style, _ value: Value, _ focus: Focus) {
        self.style = style
        self.value = value
        self.focus = focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func merge(_ other: Self) -> Update? {
        guard let update = Update(self, other) else { return nil }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        if update.contains(.style) { self.style = other.style }
        if update.contains(.value) { self.value = other.value }
        if update.contains(.focus) { self.focus = other.focus }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return update
    }
}
