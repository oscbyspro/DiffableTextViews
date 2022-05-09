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
    public typealias Value  = Style.Value
    public typealias State  = DiffableTextKit.Remote<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var _storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ state: State, _ field: Field) {
        self._storage = Storage(state, field)
    }
    
    @inlinable public init(_ state: State) {
        switch state.focus.wrapped {
        case  true: self =   .focused(state.style, state.value)
        case false: self = .unfocused(state.style, state.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(State(style, commit.value, true), Field((commit.snapshot)))
    }
    
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(State(style, value, false), Field(Snapshot(style.format(value), as: .phantom)))
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
        
        @usableFromInline var state: State
        @usableFromInline var field: Field
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ state: State, _ field: Field) {
            self.state = state
            self.field = field
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(state, field)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Accessors
//=----------------------------------------------------------------------------=

public extension Context {

    //=------------------------------------------------------------------------=
    // MARK: 1st
    //=------------------------------------------------------------------------=
        
    @inlinable internal var state: State {
        _storage.state
    }
    
    @inlinable internal var field: Field {
        _storage.field
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 2nd
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style {
        state.style
    }
    
    @inlinable var value: Value {
        state.value
    }
    
    @inlinable var focus: Focus {
        state.focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 3rd
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
        
    @inlinable internal mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // Focused
        //=--------------------------------------=
        if other.focus.wrapped {
            self.write {
                $0.state = other.state
                $0.field.update(snapshot: other.snapshot)
            }
        //=--------------------------------------=
        // Unfocused
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Remote
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: State) -> Bool {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        let (result, update) = self.state + remote
        //=--------------------------------------=
        // At Least On Value Must Be Unique
        //=--------------------------------------=
        guard !update.isEmpty else { return false }
        //=--------------------------------------=
        // Insert
        //=--------------------------------------=
        self.merge(Self(result)); return true
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
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func set(selection: Index) {
        self.write({ $0.field.selection = Carets(selection) })
    }
    
    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        self.write({ $0.field  .update(selection: Carets(selection), momentum: momentum) })
    }
}
