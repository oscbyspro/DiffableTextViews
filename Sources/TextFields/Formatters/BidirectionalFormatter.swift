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
