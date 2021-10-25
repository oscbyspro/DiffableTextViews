//
//  NumericTextSchemeFloat32.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeFloat32

public enum NumericTextSchemeFloat32: NumericTextFloatScheme {
    public typealias Number = Float32
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Precision
    
    public static let maxTotalDigits: Int = 6
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeFloat32.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeFloat32
}


