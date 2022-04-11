//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Remote
//*===========================================================================

/// A model used to collect upstream and downstream values.
public struct Remote<Style: DiffableTextStyle> {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let focus: Focus
    public let style: Style
    public let value: Value

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(focus: Focus, style: Style, value: Value) {
        self.focus = focus
        self.style = style
        self.value = value
    }
    
    @inlinable public init(style: Style, value: Value, focus: Focus) {
        self.focus = focus
        self.style = style
        self.value = value
    }
}
