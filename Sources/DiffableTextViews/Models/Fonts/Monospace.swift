//
//  Monospace.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

// MARK: Monospace

public struct Monospace {
    
    // MARK: Properties
    
    @usableFromInline let template: UIFontDescriptor
    
    // MARK: Initializers
    
    @inlinable init(_ base: UIFont) {
        self.template = base.fontDescriptor
    }
    
    // MARK: Instances
    
    public static let text   = Self(     .monospacedSystemFont(ofSize: .zero, weight: .regular))
    public static let digits = Self(.monospacedDigitSystemFont(ofSize: .zero, weight: .regular))
}

#endif
