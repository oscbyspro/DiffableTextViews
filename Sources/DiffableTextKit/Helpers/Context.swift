//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Context
//*============================================================================*

public final class Context<Style: DiffableTextStyle, Scheme: DiffableTextKit.Scheme> {
    public typealias Field = DiffableTextKit.Field<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    public typealias Commit = DiffableTextKit.Commit<Style.Value>
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    public private(set) var value: Value! = nil
    public private(set) var style: Style! = nil
    public private(set) var field: Field = Field()
    public private(set) var active: Bool = false
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable func active(style: Style, commit: Commit) {
        self.active = true
        self.style  = style
        self.value  = commit.value
        self.field.update(snapshot: commit.snapshot)
    }
    
    @inlinable func inactive(style: Style, value: Value) {
        self.active = false
        self.value  = value
        self.style  = style
        self.field  = Field()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func set(selection: Field.Layout.Index) {
        self.field.selection = selection ..< selection
    }
    
    @inlinable func update(selection: Range<Position>, momentum: Bool) {
        self.field.update(selection: selection, momentum: momentum)
    }
}
