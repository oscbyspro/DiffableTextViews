//
//  &Optional.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

extension Optional {
    @inlinable func replace(none replacement: @autoclosure () -> Wrapped) -> Wrapped {
        self ?? replacement()
    }
}
