//
//  BidirectionalFormatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

@usableFromInline protocol BidirectionalFormatter: Formatter {
    associatedtype ParseFailure: Error = Never

    typealias ParseInput = FormatOutput
    typealias ParseOutput = FormatInput
    
    func parse(_ value: ParseInput) -> Result<ParseOutput, ParseFailure>
}


protocol _Formatter {
    associatedtype Value
    associatedtype ParseFailure: Error
 
    func format(_ value: Value) -> Result<String, Never>
    func parse(_ value: String) -> Result<Value, ParseFailure>
    func snapshot(_ value: String) -> Result<Snapshot, Never>
}
