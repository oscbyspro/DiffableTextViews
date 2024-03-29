//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Lock
//*============================================================================*

@MainActor public final class Lock {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var count: UInt = 0
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var isLocked: Bool {
        self.count != 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func lock() {
        self.count += 1
    }
    
    @inlinable @inline(__always) func open() {
        self.count -= 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func perform(action: () throws -> Void) {
        self.lock(); try? action(); self.open()
    }
    
    @inlinable public func task(operation: @escaping () async throws -> Void) {
        _ = asynchronous(operation: operation)
    }
    
    @inlinable public func task(operation: @escaping () async throws -> Void) async {
        await asynchronous(operation: operation).value
    }
    
    @inlinable @inline(__always) @discardableResult func asynchronous(
    operation: @escaping () async throws -> Void) -> Task<Void, Never> {
        self.lock(); return Task { try? await operation(); self.open() }
    }
}
