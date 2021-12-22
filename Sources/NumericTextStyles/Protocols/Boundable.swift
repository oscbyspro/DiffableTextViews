//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Boundable

#warning("Rename as BoundableTextValue, maybe.")
public protocol Boundable: Comparable {
    
    // MARK: Requirements
    
    /// The zero value.
    @inlinable static var zero: Self { get }
    
    /// - Less than or equal to zero.
    @inlinable static var minLosslessValue: Self { get }
    
    /// - Greater than or equal to zero.
    @inlinable static var maxLosslessValue: Self { get }
}
