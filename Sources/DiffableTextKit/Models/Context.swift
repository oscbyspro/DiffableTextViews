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

public struct Context<Style: DiffableTextStyle, Scheme: DiffableTextKit.Scheme> {
    public typealias Field = DiffableTextKit.Field<Scheme>
    public typealias Layout = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    public typealias Remote = DiffableTextKit.Remote<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>
    public typealias Value = Style.Value

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
    
    @inlinable init(_ focus: Focus, _ style: Style, _ value: Value, _ snapshot: Snapshot) {
        self._focus = focus; self._style = style
        self._value = value; self._field = Field(Layout(snapshot))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var style: Style {
        _style
    }
    
    @inlinable public var value: Value {
        _value
    }
    
    @inlinable public var focus: Focus {
        _focus
    }
    
    @inlinable public var field: Field {
        _field
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var layout: Layout {
        _field.layout
    }
    
    @inlinable public var text: String {
        _field.layout.snapshot.characters
    }
    
    @inlinable public var selection: Range<Position> {
        _field.selection.lowerBound.position ..< _field.selection.upperBound.position
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

public extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=

    @inlinable init(_ remote: Remote) {
        switch remote.focus.value {
        case  true: self =   .focused(remote.style, remote.value)
        case false: self = .unfocused(remote.style, remote.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Style / Value
    //=------------------------------------------------------------------------=
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(true, style, commit.value, commit.snapshot)
    }
 
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(false, style, value, Snapshot(style.format(value), as: .phantom))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension Context {

    //=------------------------------------------------------------------------=
    // MARK: Other
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // MARK: Focused
        //=--------------------------------------=
        if other._focus.value {
            self._focus = other._focus
            self._style = other._style
            self._value = other._value
            self._field.update(layout: other._field.layout)
        //=--------------------------------------=
        // MARK: Unfocused
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Remote) -> Bool {
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
        self.merge(Self(Remote(
        focus: changeInFocus ? remote.focus : focus,
        style: changeInStyle ? remote.style : style,
        value: changeInValue ? remote.value : value)))
        return true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func set(selection: Layout.Index) {
        self._field.selection = Range(uncheckedBounds: (selection, selection))
    }
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        self._field.update(selection: selection, momentum: momentum)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable func merged(_ input: String, in range: Range<Position>) throws -> Self {
        var result = self; try result.merge(input, in: range); return result
    }
    
    @inlinable mutating func merge(_ input: String, in range: Range<Position>) throws {
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let indices = field.indices(at: range)
        let range = Range(uncheckedBounds: (indices.lowerBound.subindex, indices.upperBound.subindex))
        let commit = try style.merge(Changes(to: layout.snapshot, with: input, in: range))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.set(selection: indices.upperBound)
        self.merge(Self.focused(style, commit))
    }
}
