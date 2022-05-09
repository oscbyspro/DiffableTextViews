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
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var _storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status, _ layout: Layout) {
        self._storage = Storage(status, layout)
    }
    
    @inlinable public init(_ status: Status) {
        switch status.focus.wrapped {
        case  true: self =   .focused(status.style, status.value)
        case false: self = .unfocused(status.style, status.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(Status(style, commit.value, true), Layout((commit.snapshot)))
    }
    
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(Status(style, value, false), Layout(Snapshot(style.format(value), as: .phantom)))
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
        
        @usableFromInline var status: Status
        @usableFromInline var layout: Layout
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ layout: Layout) {
            self.status = status
            self.layout = layout
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(status, layout)
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
        
    @inlinable internal var status: Status {
        _storage.status
    }
    
    @inlinable internal var layout: Layout {
        _storage.layout
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 2nd
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style {
        status.style
    }
    
    @inlinable var value: Value {
        status.value
    }
    
    @inlinable var focus: Focus {
        status.focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 3rd
    //=------------------------------------------------------------------------=

    @inlinable var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable var text: String {
        layout.snapshot.characters
    }
    
    @inlinable func selection<T>(as type: Position<T>.Type =
    Position<T>.self) -> Range<T.Position> where T: Offset {
        layout.positions(at: layout.selection).bounds
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
                $0.status = other.status
                $0.layout.update(snapshot: other.snapshot)
            }
        //=--------------------------------------=
        // Unfocused
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Status
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ status: Status) -> Bool {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        let (result, update) = self.status + status
        //=--------------------------------------=
        // At Least One Must Be Different
        //=--------------------------------------=
        return (!update.isEmpty).on(true) {
            self.merge(Self.init(result))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func merge<T>(_ characters: String,
    in range: Range<T.Position>) throws where T: Offset {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let carets = layout.indices(at: Carets(range))
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
        self.write({ $0.layout.selection = Carets(selection) })
    }
    
    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        self.write({ $0.layout .update(selection: Carets(selection), momentum: momentum) })
    }
}
