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
        
    @usableFromInline private(set) var _value: Value! = nil
    @usableFromInline private(set) var _style: Style! = nil
    @usableFromInline private(set) var _field: Field = Field()
    @usableFromInline private(set) var _active: Bool = false
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var value: Value! { _value  }
    @inlinable public var style: Style! { _style  }
    @inlinable public var field: Field  { _field  }
    @inlinable public var active: Bool  { _active }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func active(style: Style, commit: Commit) {
        self._active = true
        self._style  = style
        self._value  = commit.value
        self._field.update(snapshot: commit.snapshot)
    }
    
    @inlinable public func inactive(style: Style, value: Value) {
        self._active = false
        self._value  = value
        self._style  = style
        self._field  = Field()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable public func set(selection: Field.Layout.Index) {
        self._field.selection = selection ..< selection
    }
    
    @inlinable public func update(selection: Range<Position>, momentum: Bool) {
        self._field.update(selection: selection, momentum: momentum)
    }
}