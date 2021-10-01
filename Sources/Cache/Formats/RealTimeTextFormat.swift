//
//  RealTimeTextFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

protocol RealTimeTextFormat: Format where Output == String {
    associatedtype Layout: Format where Layout.Input == Output, Layout.Output == Snapshot, Layout.Failure == Never
    
    // MARK: Get
    
    var layout: Layout { get }
}

extension RealTimeTextFormat {
    // MARK: Snapshot
    
    @inlinable func snapshot(_ value: Output) -> Snapshot {
        layout.format(value).get()
    }
}
