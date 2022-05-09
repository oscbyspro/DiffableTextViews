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
public struct Status<Style: DiffableTextStyle> {
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
    
    @inlinable public mutating func merge(_ other: Self) -> Update {
        let update = (self .!= other)
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

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func .!= (lhs: Self, rhs: Self) -> Update {
        var update = Update()
        //=--------------------------------------=
        // Compare
        //=--------------------------------------=
        if lhs.style != rhs.style { update.formUnion(.style) }
        if lhs.value != rhs.value { update.formUnion(.value) }
        if lhs.focus != rhs.focus { update.formUnion(.focus) }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return update
    }
    
    @inlinable static func + (lhs: Self, rhs: Self) -> (Self, Update) {
        var result = lhs; let update = result.merge(rhs); return (result, update)
    }
}
