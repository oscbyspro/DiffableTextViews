//
//  PatternTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews

//*============================================================================*
// MARK: * Strings
//*============================================================================*

public extension DiffableTextStyle where Self == PatternTextStyle<String, String> {
    @inlinable static func pattern(_ pattern: String, placeholder: Character) -> Self {
        .init(pattern: pattern, placeholder: placeholder)
    }
}
