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
// MARK: * Cache
//*============================================================================*

public final class Cache<ID, Value> where ID: Hashable, Value: AnyObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let nscache: NSCache<Key, Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.nscache = NSCache()
    }

    @inlinable public convenience init(_ max: Int) {
        self.init(); self.nscache.countLimit = max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Search or Insert
    //=------------------------------------------------------------------------=
    
    @inlinable public func reuseable(_ id: ID, make: @autoclosure () throws -> Value) rethrows -> Value {
        let key = Key(id)
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        if let instance = nscache.object(forKey: key) {
            return instance
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = try make()
            nscache.setObject(instance,  forKey: key)
            return instance
        }
    }
    
    //*========================================================================*
    // MARK: * Key
    //*========================================================================*
    
    @usableFromInline final class Key: NSObject {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let wrapped: ID
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ wrapped: ID) { self.wrapped = wrapped }
        
        //=--------------------------------------------------------------------=
        // MARK: NSCache
        //=--------------------------------------------------------------------=
     
        @inlinable override var hash: Int {
            var hasher = Hasher(); wrapped.hash(into: &hasher); return hasher.finalize()
        }
        
        @inlinable override func isEqual(_ object: Any?) -> Bool {
            wrapped == (object as! Self).wrapped
        }
    }
}
