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

/// Values describing the state of a diffable text view.
public struct Context<Style: DiffableTextStyle, Scheme: DiffableTextKit.Scheme> {
    public typealias Value = Style.Value
    public typealias Commit = Style.Commit
    public typealias Remote = Style.Remote
    public typealias Position = Scheme.Position
    @usableFromInline typealias Field = Scheme.Field
    @usableFromInline typealias Index = Scheme.Index
    @usableFromInline typealias Layout = Scheme.Layout

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var _storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage) {
        self._storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Transforms this instance with copy-on-write behavior.
    @inlinable mutating func write(_ write: (Storage) -> Void) {
        //=--------------------------------------=
        // MARK: Unique
        //=--------------------------------------=
        if !isKnownUniquelyReferenced(&_storage) {
            self._storage = self._storage.copy()
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        write(self._storage)
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var focus: Focus
        @usableFromInline var style: Style
        @usableFromInline var value: Value
        @usableFromInline var field: Field
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ focus: Focus, _ style: Style, _ value: Value, _ field: Field) {
            self.focus = focus; self.style = style; self.value = value; self.field = field
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(focus, style, value, field)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

public extension Context {

    //=------------------------------------------------------------------------=
    // MARK: 1st
    //=------------------------------------------------------------------------=
    
    @inlinable var focus: Focus {
        _storage.focus
    }
    
    @inlinable var style: Style {
        _storage.style
    }
    
    @inlinable var value: Value {
        _storage.value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 2nd
    //=------------------------------------------------------------------------=

    @inlinable internal var field: Field {
        _storage.field
    }
    
    @inlinable var snapshot: Snapshot {
        field.layout.snapshot
    }
    
    @inlinable var text: String {
        field.layout.snapshot.characters
    }
    
    @inlinable var selection: Range<Position> {
        field.selection.lowerBound.position ..<
        field.selection.upperBound.position
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
    // MARK: Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(Storage(true, style, commit.value, Field(Layout(commit.snapshot))))
    }
 
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(Storage(false, style, value, Field(Layout(Snapshot(style.format(value), as: .phantom)))))
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
        if other.focus.value {
            self.write {
                $0.focus = other.focus
                $0.style = other.style
                $0.value = other.value
                $0.field.update(layout: other.field.layout)
            }
        //=--------------------------------------=
        // MARK: Unfocused
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Remote) -> Bool {
        //=--------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------=
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
    // MARK: Replacement
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func merge(_ replacement: String,
    in range: Range<Position>) throws {
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let indices = field.indices(at: range)
        let commit = try style.merge(Changes(
        to: snapshot, as: replacement, in: indices.subindices))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.set(selection: indices.upperBound)
        self.merge(Self.focused(style, commit))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func set(selection: Index) {
        self.write { $0.field.selection = .empty(selection) }
    }
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        self.write { $0.field.update(selection: selection, momentum: momentum) }
    }
}
