//
//  EmptyFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

@usableFromInline struct EmptyFormat<Value>: Format {
    // MARK: Protocol: Format
    
    @inlinable func format(_ value: Value) -> Result<Value, Never> {
        .success(value)
    }
}

extension EmptyFormat: ParsableFormat {
    // MARK: Protocol: ParsableFormat
    
    @inlinable var parser: Self { self }
}
