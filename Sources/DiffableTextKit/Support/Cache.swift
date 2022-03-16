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

public final class Cache<Key, Value> where Key: Hashable, Value: AnyObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let nscache: NSCache<NSKey, Value>
    
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func access(_ key: Key) -> Value? {
        nscache.object(forKey: NSKey(key))
    }
    
    @inlinable public func insert(_ value: Value, as key: Key) {
        nscache.setObject(value, forKey: NSKey(key))
    }
    
    @inlinable public func remove(_ key: Key) {
        nscache.removeObject(forKey: NSKey(key))
    }

    @inlinable public func reuse(_ key: Key, make: @autoclosure () throws -> Value) rethrows -> Value {
        let key = NSKey(key)
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
    // MARK: * NSKey
    //*========================================================================*
    
    /// A key compatible with NSCache.
    ///
    /// NSCache keys do not use Swift's Hashable protocol, instead,
    /// they must subclass NSObject and override hash and isEqual(\_:).
    ///
    @usableFromInline final class NSKey: NSObject {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let wrapped: Key
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ wrapped: Key) { self.wrapped = wrapped }
        
        //=--------------------------------------------------------------------=
        // MARK: NSCache
        //=--------------------------------------------------------------------=
     
        @inlinable override var hash: Int {
            wrapped.hashValue
        }
        
        @inlinable override func isEqual(_ object: Any?) -> Bool {
            wrapped == (object as! Self).wrapped
        }
    }
}
