//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("WIP")
#warning("WIP")
#warning("WIP")
//*============================================================================*
// MARK: * Market
//*============================================================================*

@usableFromInline final class Market {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region: Region
    @usableFromInline let labels: NSCache<NSString, Label>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(in region: Region) {
        self.region = region
        self.labels = NSCache()
        self.labels.countLimit = 10
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Label
    //=------------------------------------------------------------------------=
    
    @inlinable func label(code: String) -> Label {
        let key = code as NSString
        //=--------------------------------------=
        // MARK: Search In Cache
        //=--------------------------------------=
        if let reusable = labels.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = Label.currency(code: code, in: region)
            self.labels.setObject(instance, forKey: key)
            return instance
        }
    }
}
