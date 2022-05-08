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
    
    public let style: Style
    public let value: Value
    public let focus: Focus

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(style: Style, value: Value, focus: Focus) {
        self.style = style
        self.value = value
        self.focus = focus
    }
}
