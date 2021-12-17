//
//  Aliases.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-09.
//

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Aliases

#if os(iOS)

public enum Format {
    public typealias Precision = NumberFormatStyleConfiguration.Precision
    public typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
}

#endif
