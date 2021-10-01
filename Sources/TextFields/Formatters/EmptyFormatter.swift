//
//  EmptyFormatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

@usableFromInline struct EmptyFormatter<Value>: Formatter {
    @usableFromInline typealias FormatInput = Value
    @usableFromInline typealias FormatOutput = Value
    @usableFromInline typealias FormatError = Never
    
    // MARK: Protocol: Formatter
    
    @inlinable func format(_ value: Value) -> Result<Value, Never> {
        .success(value)
    }
}

extension EmptyFormatter: BidirectionalFormatter {
    @usableFromInline typealias ParseFailure = Never
    
    // MARK: Protocol: BidirectionalFormatter
    
    @inlinable func parse(_ value: Value) -> Result<Value, Never> {
        .success(value)
    }
}

extension EmptyFormatter: RealTimeTextFormatter where FormatOutput == String {
    // MARK: Protocol: RealTimeTextFormatter
    
    @inlinable func snapshot(_ value: String) -> Snapshot {
        value.reduce(map: Symbol.content)
    }
}
