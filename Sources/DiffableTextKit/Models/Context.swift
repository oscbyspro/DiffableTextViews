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
    public typealias Update   = DiffableTextKit.Update<Style>
    public typealias Commit   = DiffableTextKit.Commit<Value>
    public typealias Field    = DiffableTextKit.Field<Scheme>
    public typealias Layout   = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    public typealias Value    = Style.Value

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
    
    @inlinable public init(_ update: Update) {
        self._style = update.style
        self._value = update.value
        self._focus = update.focus
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
// MARK: + Update
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
    // MARK: Focus
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
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(_ update: Update) -> Bool {
        let changeInStyle = style != update.style
        let changeInValue = value != update.value
        let changeInFocus = focus != update.focus
        //=--------------------------------------=
        // MARK: At Least One Must Change
        //=--------------------------------------=
        guard changeInStyle || changeInValue || changeInFocus else { return false }
        dynamic(style: changeInStyle ? update.style : style, value: update.value, focus: update.focus)
        return true
    }
}
