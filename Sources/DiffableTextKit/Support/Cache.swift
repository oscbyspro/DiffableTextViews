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
    
    @usableFromInline let nscache: NSCache<Wrapper, Value>
    
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
    
    @inlinable public func access(key: Key) -> Value? {
        nscache.object(forKey: Wrapper(key))
    }
    
    @inlinable public func insert(_ value: Value, key: Key) {
        nscache.setObject(value, forKey: Wrapper(key))
    }
    
    @inlinable public func remove(key: Key) {
        nscache.removeObject(forKey: Wrapper(key))
    }

    @inlinable public func reuseable(_ key: Key, make: @autoclosure () throws -> Value) rethrows -> Value {
        let key = Wrapper(key)
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
    
    @usableFromInline final class Wrapper: NSObject {
        
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
