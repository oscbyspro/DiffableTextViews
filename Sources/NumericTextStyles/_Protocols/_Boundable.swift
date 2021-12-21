//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Boundable

#warning("WIP")
public protocol _Boundable: Comparable {
    
    // MARK: Requirements
    
    /// The zero value.
    @inlinable static var zero: Self { get }
    
    /// - Less than or equal to zero.
    @inlinable static var minLosslessValue: Self { get }
    
    /// - Greater than or equal to zero.
    @inlinable static var maxLosslessValue: Self { get }
}

// MARK: - Utilities

extension _Boundable {
    
    // MARK: Descriptions
    
    @inlinable static var isUnsigned: Bool {
        minLosslessValue >= .zero
    }
    
    @inlinable static var isSigned: Bool {
        minLosslessValue <= .zero
    }
}
