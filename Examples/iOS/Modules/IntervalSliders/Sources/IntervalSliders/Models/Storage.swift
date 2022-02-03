//
//  Storage.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Storage
//*============================================================================*

@usableFromInline final class Storage {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let values: Binding<(CGFloat, CGFloat)>
    @usableFromInline let valuesLimits: ClosedRange<CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ values: Binding<(CGFloat, CGFloat)>, in valuesLimits: ClosedRange<CGFloat>) {
        self.values = values; self.valuesLimits = valuesLimits
    }
}
