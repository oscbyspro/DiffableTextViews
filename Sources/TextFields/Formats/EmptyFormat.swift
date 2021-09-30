//
//  EmptyFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

import Foundation

struct EmptyFormat<Value>: ParsableFormat {
    // MARK: Format
    
    @inlinable func format(_ value: Value) -> Result<Value, Never> {
        .success(value)
    }
    
    // MARK: ParsableFormat
    
    @inlinable var inverse: Self { self }
}
