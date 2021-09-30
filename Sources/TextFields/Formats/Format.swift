//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

protocol Format {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error = Never
    
    // MARK: Format
    
    func format(_ value: Input) -> Result<Output, Failure>
}
