//
//  PatternTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews

//*============================================================================*
// MARK: * String / String
//*============================================================================*

public extension DiffableTextStyle where Self == PatternTextStyle<String, String> {
    @inlinable static func pattern(_ pattern: String) -> Self { Self(pattern) }
}
