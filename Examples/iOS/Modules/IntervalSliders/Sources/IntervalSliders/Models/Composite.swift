//
//  Composite.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

//*============================================================================*
// MARK: * Sliders x Composite
//*============================================================================*

@usableFromInline final class Composite: Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let layout:  Layout
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, _ layout: Layout) {
        self.layout  = layout
        self.storage = storage
    }
}
