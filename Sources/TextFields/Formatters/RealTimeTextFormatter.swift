//
//  RealTimeTextFormatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

@usableFromInline protocol RealTimeTextFormatter: Formatter where FormatOutput == String {
    func snapshot(_ value: FormatOutput) -> Snapshot
}
