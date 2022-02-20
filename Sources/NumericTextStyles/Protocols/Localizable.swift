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
// MARK: * ID
//*============================================================================*

@usableFromInline protocol Localizable: AnyObject, Hashable {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable var  locale: Locale { get }
    
    @inlinable func update(_ formatter: NumberFormatter)
    
    @inlinable func links<T: Component>(_ formatter: NumberFormatter) -> Links<T>
}
