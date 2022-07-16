//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Aliases
//*============================================================================*

public typealias _WIP_NumberTextStyle<Kind: _Kind> = Kind.NumberTextGraph.Style

//=----------------------------------------------------------------------------=
// MARK: + Standard
//=----------------------------------------------------------------------------=

public extension _Style where Graph.Format: _Format_Percentable {
    typealias Percent = _Style<Graph.Percent>
}

public extension _Style where Graph.Format: _Format_Currencyable {
    typealias Currency = _Style<Graph.Currency>
}

//=----------------------------------------------------------------------------=
// MARK: + Optional
//=----------------------------------------------------------------------------=

public extension _Optional where Graph.Format: _Format_Percentable {
    typealias Percent = _Optional<Graph.Percent>
}

public extension _Optional where Graph.Format: _Format_Currencyable {
    typealias Currency = _Optional<Graph.Currency>
}
