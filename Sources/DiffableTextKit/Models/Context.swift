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
//*============================================================================*

/// A set of values describing the state of a diffable text view.
///
/// - Uses copy-on-write semantics.
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
    
    @inlinable init(_ style: Style, _ value: Value, _ focus: Focus) {
        self = focus.value ? .focused(style, value) : .unfocused(style, value)
    }
    
    @inlinable public init(_ remote: Remote) {
        self.init(remote.style, remote.value, remote.focus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(Storage(style, commit.value, true, Field((commit.snapshot))))
    }
 
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(Storage(style, value, false, Field(Snapshot(style.format(value), as: .phantom))))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Transforms this instance with copy-on-write behavior.
    @inlinable mutating func write(_ write: (Storage) -> Void) {
        //=--------------------------------------=
        // Unique
        //=--------------------------------------=
        if !isKnownUniquelyReferenced(&_storage) {
            self._storage = self._storage.copy()
        }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        write(self._storage)
    }
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var style: Style
        @usableFromInline var value: Value
        @usableFromInline var focus: Focus
        @usableFromInline var field: Field
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ style: Style, _ value: Value, _ focus: Focus, _ field: Field) {
            self.style = style
            self.value = value
            self.focus = focus
            self.field = field
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(style, value, focus, field)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Accessors
//=----------------------------------------------------------------------------=

public extension Context {

    //=------------------------------------------------------------------------=
    // MARK: Primary
    //=------------------------------------------------------------------------=
        
    @inlinable var style: Style {
        _storage.style
    }
    
    @inlinable var value: Value {
        _storage.value
    }
    
    @inlinable var focus: Focus {
        _storage.focus
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
// MARK: Transformations
//=----------------------------------------------------------------------------=

public extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Context
    //=------------------------------------------------------------------------=
        
    @inlinable internal mutating func merge(_ context: Self) {
        //=--------------------------------------=
        // Focused
        //=--------------------------------------=
        if context.focus.value {
            self.write {
                $0.style = context.style
                $0.value = context.value
                $0.focus = context.focus
                $0.field.update(snapshot: context.snapshot)
            }
        //=--------------------------------------=
        // Unfocused
        //=--------------------------------------=
        } else { self = context }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func merge<T>(_ characters: String,
    in range: Range<T.Position>) throws where T: Offset {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let carets = field.indices(at: Carets(range))
        let commit = try style.merge(Proposal(
        snapshot, with: characters, in: carets.bounds))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.set(selection: carets.upperBound)
        self.merge(Self.focused(style, commit))
    }

    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Remote) -> Bool {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let changeInStyle = remote.style != style
        let changeInValue = remote.value != value
        let changeInFocus = remote.focus != focus
        //=--------------------------------------=
        // At Least One Must Have Changed
        //=--------------------------------------=
        guard changeInStyle
           || changeInValue
           || changeInFocus else { return false }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.merge(Self(
        changeInStyle ? remote.style : style,
        changeInValue ? remote.value : value,
        changeInFocus ? remote.focus : focus))
        return true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func set(selection: Index) {
        self.write({ $0.field.selection = Carets(selection) })
    }
    
    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        self.write({ $0.field  .update(selection: Carets(selection), momentum: momentum) })
    }
}
