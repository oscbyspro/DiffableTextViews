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

/// A set of values describing the state of a diffable text view.
///
/// - Uses copy-on-write.
///
public struct Context<Style: DiffableTextStyle> {
    public typealias Commit = DiffableTextKit.Commit<Value>
    public typealias Remote = DiffableTextKit.Remote<Style>
    public typealias Value  = Style.Value

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
    // MARK: Primary
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
    
    @inlinable internal var field: Field {
        _storage.field
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Secondary
    //=------------------------------------------------------------------------=

    @inlinable var snapshot: Snapshot {
        field.snapshot
    }
    
    @inlinable var text: String {
        field.snapshot.characters
    }
    
    @inlinable func selection<T>(as type: Position<T>.Type =
    Position<T>.self) -> Range<T.Position> where T: Offset {
        field.positions(at: field.selection).bounds
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
    // MARK: Primitives
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable internal static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(Storage(true, style, commit.value, Field((commit.snapshot))))
    }
 
    @inlinable internal static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(Storage(false, style, value, Field(Snapshot(style.format(value), as: .phantom))))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Context
    //=------------------------------------------------------------------------=
        
    @inlinable internal mutating func merge(_ context: Self) {
        //=--------------------------------------=
        // MARK: Focused
        //=--------------------------------------=
        if context.focus.value {
            self.write {
                $0.focus = context.focus
                $0.style = context.style
                $0.value = context.value
                $0.field.update(snapshot: context.snapshot)
            }
        //=--------------------------------------=
        // MARK: Unfocused
        //=--------------------------------------=
        } else { self = context }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func merge<T>(_ characters: String,
    in range: Range<T.Position>) throws where T: Offset {
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let carets = field.indices(at: Carets(range))
        let commit = try style.merge(Changes.init(
        snapshot, with: characters, in: carets.bounds))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.set(selection: carets.upperBound)
        self.merge(Self.focused(style, commit))
    }

    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Remote) -> Bool {
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let changeInStyle = remote.style != style
        let changeInValue = remote.value != value
        let changeInFocus = remote.focus != focus
        //=--------------------------------------=
        // MARK: At Least One Must Have Changed
        //=--------------------------------------=
        guard changeInStyle
           || changeInValue
           || changeInFocus else { return false }
        //=--------------------------------------=
        // MARK: Update
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
    
    @inlinable internal mutating func set(selection: Index) {
        self.write({ $0.field.selection = .caret(at: selection) })
    }
    
    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        self.write({ $0.field.update(selection: Carets(selection), momentum: momentum) })
    }
}
