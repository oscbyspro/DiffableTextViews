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
    public typealias Commit = DiffableTextKit.Commit<Value>
    public typealias Remote = DiffableTextKit.Remote<Style>
    public typealias Field = DiffableTextKit.Field<Scheme>
    public typealias Layout = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var _style: Style
    @usableFromInline private(set) var _value: Value
    @usableFromInline private(set) var _focus: Focus
    @usableFromInline private(set) var _field: Field
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ remote: Remote) {
        self._style = remote.style
        self._value = remote.value
        self._focus = remote.focus
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

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

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
    
    //=------------------------------------------------------------------------=
    // MARK: Style, Value, Focus
    //=------------------------------------------------------------------------=
    
    @inlinable public func focus(style: Style, commit: Commit) {
        self._focus = true
        self._style = style
        self._value = commit.value
        self._field.update(snapshot: commit.snapshot)
    }
    
    @inlinable public func unfocus(style: Style, value: Value) {
        self._focus = false
        self._style = style
        self._value = value
        self._field = Field()
    }

    @inlinable public func accept(style: Style, value: Value, focus: Focus) {
        switch focus.value {
        case   true: self  .focus(style: style,commit: style.interpret(value))
        case  false: self.unfocus(style: style, value: value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(_ remote: Remote) -> Bool {
        let changeInStyle = remote.style != style
        let changeInValue = remote.value != value
        let changeInFocus = remote.focus != focus
        //=--------------------------------------=
        // MARK: At Least One Value Must Change
        //=--------------------------------------=
        guard changeInStyle
           || changeInValue
           || changeInFocus else { return false }
        //=--------------------------------------=
        // MARK: Yes
        //=--------------------------------------=
        self.accept(
        style: changeInStyle ? remote.style : style,
        value: changeInValue ? remote.value : value,
        focus: changeInFocus ? remote.focus : focus)
        return true
    }
}
