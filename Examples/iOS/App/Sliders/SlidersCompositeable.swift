//
//  SlidersCompositeable.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//



import SwiftUI

//*============================================================================*
// MARK: * SlidersCompositeable
//*============================================================================*

protocol SlidersCompositeable: SlidersLayoutable, SlidersStorageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    var composite: SlidersComposite { get }
}

//=------------------------------------------------------------------------=
// MARK: SlidersCompositeable - Details
//=------------------------------------------------------------------------=

extension SlidersCompositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var layout: SlidersLayout {
        composite.layout
    }
    
    var storage: SlidersStorage {
        composite.storage
    }
}
