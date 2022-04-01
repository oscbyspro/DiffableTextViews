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
    public typealias Value    = Style.Value
    public typealias Commit   = DiffableTextKit.Commit<Value>
    public typealias Field    = DiffableTextKit.Field<Scheme>
    public typealias Layout   = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var _focus: Focus
    @usableFromInline private(set) var _style: Style
    @usableFromInline private(set) var _value: Value
    @usableFromInline private(set) var _field: Field
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ style: Style, _ value: Value) {
        self._focus = false
        self._style = style
        self._value = value
        self._field = Field()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var style: Style { _style }
    @inlinable public var value: Value { _value }
    @inlinable public var focus: Focus { _focus }
    @inlinable public var field: Field { _field }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func formatted() -> String {
        style.format(value)
    }
}

//=------------------------------------------------------------------------=
// MARK: Update
//=------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable public func set(selection: Layout.Index) {
        self._field.selection = selection ..< selection
    }
    
    @inlinable public func update(selection: Range<Position>, momentum: Bool) {
        self._field.update(selection: selection, momentum: momentum)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Update
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Unfocused / Focused / Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable public func unfocused(style: Style, value: Value) {
        self._focus = false
        self._style = style
        self._value = value
        self._field = Field()
    }
    
    @inlinable public func focused(style: Style, commit: Commit) {
        self._focus = true
        self._style = style
        self._value = commit.value
        self._field.update(snapshot: commit.snapshot)
    }

    @inlinable public func dynamic(style: Style, value: Value, focus: Focus) {
        switch focus.value {
        case false: self.unfocused(style: style, value: value)
        case  true: self  .focused(style: style,commit: style.interpret(value))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Update
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Pull
    //=------------------------------------------------------------------------=
    
    @inlinable public func pull(style: Style, value: Value, focus: Focus) -> Bool {
        let changeInStyle = self.style != style
        let changeInValue = self.value != value
        let changeInFocus = self.focus != focus
        //=--------------------------------------=
        // MARK: At Least One Has To Change
        //=--------------------------------------=
        guard changeInStyle || changeInValue || changeInFocus else { return false }
        dynamic(style: changeInStyle ? style : _style, value: value, focus: focus )
        return true
    }
}
