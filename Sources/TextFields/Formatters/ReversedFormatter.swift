//
//  ReversedFormatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

@usableFromInline struct ReversedFormatter<Base: BidirectionalFormatter>: BidirectionalFormatter {
    @usableFromInline typealias FormatInput = Base.FormatOutput
    @usableFromInline typealias FormatOutput = Base.FormatInput
    @usableFromInline typealias FormatFailure = Base.ParseFailure
    @usableFromInline typealias ParseFailure = Base.FormatFailure
    
    // MARK: Storage
    
    @usableFromInline let base: Base
    
    // MARK: Initialization
    
    @inlinable init(base: Base) {
        self.base = base
    }
    
    // MARK: Protocol: BidirectionalFormatter
    
    @inlinable func format(_ value: FormatInput) -> Result<FormatOutput, FormatFailure> {
        base.parse(value)
    }
    
    @inlinable func parse(_ value: ParseInput) -> Result<ParseOutput, ParseFailure> {
        base.format(value)
    }
    
    // MARK: Utilities
    
    @inlinable func reversed() -> Base {
        base
    }
}

// MARK: Others + Initialization

extension BidirectionalFormatter {
    @inlinable func reversed() -> ReversedFormatter<Self> {
        ReversedFormatter(base: self)
    }
}

