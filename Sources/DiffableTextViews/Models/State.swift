//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * State
//*============================================================================*

@usableFromInline final class State<Style: DiffableTextStyle, Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Field = DiffableTextViews.Field<Scheme>
    @usableFromInline typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value! = nil
    @usableFromInline var style: Style! = nil
    @usableFromInline var active: Bool = false
    @usableFromInline var field: Field = Field()

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        field.snapshot
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func update(style: Style, commit: Commit<Value>) {
        self.style = style
        self.value = commit.value
        self.field.update(snapshot: commit.snapshot)
    }
    
    @inlinable func set(selection: Field.Layout.Index) {
        self.field.selection = selection ..< selection
    }
    
    @inlinable func reset(style: Style, value: Value) {
        self.value = value
        self.style = style
        self.active = false
        self.field = Field()
    }
}
