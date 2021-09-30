//
//  FormatScheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

protocol FormatScheme {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error = Never
    
    // MARK: Format
    
    func format(_ content: Input) -> Result<Output, Failure>
}
