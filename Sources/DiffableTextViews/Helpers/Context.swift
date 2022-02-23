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

@usableFromInline final class Context<Style: DiffableTextStyle, Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Value = Style.Value
    @usableFromInline typealias Field = DiffableTextViews.Field<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>
    @usableFromInline typealias Commit = DiffableTextViews.Commit<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @usableFromInline private(set) var value: Value! = nil
    @usableFromInline private(set) var style: Style! = nil
    @usableFromInline private(set) var field: Field = Field()
    @usableFromInline private(set) var active: Bool = false
    
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
