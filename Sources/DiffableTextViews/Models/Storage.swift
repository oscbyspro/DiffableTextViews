//
//  Storage.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Storage
//*============================================================================*

@usableFromInline final class Storage<Style: DiffableTextStyle, Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Selection = DiffableTextViews.Selection<Scheme>
    @usableFromInline typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Value! = nil
    @usableFromInline var style: Style! = nil
    @usableFromInline var active: Bool = false
    @usableFromInline var selection: Selection = Selection()

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot { selection.layout.snapshot }
    
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
        self.selection.update(snapshot: commit.snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update - Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func change(selection: Selection.Layout.Index) {
        self.selection.range = selection ..< selection
    }
}
