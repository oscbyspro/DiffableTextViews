//
//  NumericTextOptions.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

// MARK: - NumericTextOptions

/// Number type description.
///
/// FloatingPoints are empty.
///
public struct NumericTextOptions: OptionSet {
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    // MARK: Instances: Singular
    
    public static let unsigned = Self(rawValue: 1 << 0)
    public static let integer  = Self(rawValue: 1 << 1)
    
    // MARK: Instances: Composites
    
    public static let floatingPoint   = Self()
    public static let unsignedInteger = Self([.unsigned, .integer])
}
