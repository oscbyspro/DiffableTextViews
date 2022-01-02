//
//  MonospaceTemplate.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * MonospaceTemplate
//*============================================================================*

public struct MonospaceTemplate {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let text   = Self(     .monospacedSystemFont(ofSize: .zero, weight: .regular))
    public static let digits = Self(.monospacedDigitSystemFont(ofSize: .zero, weight: .regular))
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let descriptor: UIFontDescriptor
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: UIFont) {
        self.descriptor = base.fontDescriptor
    }
}

#endif
