//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

// MARK: - Boundable

public protocol Boundable: Comparable {
    
    // MARK: Requirements
    
    @inlinable static var zero:             Self { get }
    @inlinable static var minLosslessValue: Self { get }
    @inlinable static var maxLosslessValue: Self { get }
}
