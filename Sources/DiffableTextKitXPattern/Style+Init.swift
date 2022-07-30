//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Style x Init
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + String [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == PatternTextStyle<String> {
    @inlinable public static func pattern(_ pattern: String) -> Self { Self(pattern) }
}

//=----------------------------------------------------------------------------=
// MARK: + Array<Character> [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == PatternTextStyle<[Character]> {
    @inlinable public static func pattern(_ pattern: String) -> Self { Self(pattern) }
}
