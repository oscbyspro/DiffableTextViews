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
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive(style: Style, value: Value) {
        self.value  = value
        self.style  = style
        self.active = false
    }
    
    @inlinable func active(style: Style, commit: Commit<Value>) {
        self.style = style
        self.value = commit.value
        self.field.update(snapshot: commit.snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update - Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func change(selection: Field.Layout.Index) {
        self.field.selection = selection ..< selection
    }
}
