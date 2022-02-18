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

public final class Cache<Key, Value> where Key: Hashable & AnyObject, Value: AnyObject {
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable public convenience init(size: Int) {
        self.init()
        self.nscache.countLimit = size
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(key: Key) -> Value? {
        get { nscache.object(forKey: key) }
        set { newValue != nil ? nscache.setObject(newValue!, forKey: key) : nscache.removeObject(forKey: key) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Search or Insert
    //=------------------------------------------------------------------------=
    
    @inlinable public func search(_ key: Key, _ make: () throws -> Value) rethrows -> Value {
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        if let reusable = nscache.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = try make()
            nscache.setObject(instance, forKey: key)
            return instance
        }
    }
    
    @inlinable public func search(_ key: Key, _ make: @autoclosure () throws -> Value) rethrows -> Value {
        try search(key, make)
    }
}
