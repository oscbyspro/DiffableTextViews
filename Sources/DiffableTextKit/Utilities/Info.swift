//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Info
//*============================================================================*

/// An error message that contains a description in DEBUG mode.
///
/// It uses conditional compilation such that it has no size or cost in RELEASE mode.
///
@resultBuilder public struct Info: CustomStringConvertible, Error, Equatable,
ExpressibleByStringInterpolation, ExpressibleByStringLiteral {
    public static let unknown = "[REDACTED]"
    public static let separator = "\u{0020}"
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    #if DEBUG
    @usableFromInline var content: [String]
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ content: @autoclosure () -> [String] = []) {
        #if DEBUG
        self.content = content()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public init(stringLiteral content: String) {
        self.init([content])
    }
    
    @inlinable @inline(__always)
    public init(_  info: @autoclosure () -> Self) {
        self.init([info().description])
    }
    
    @inlinable @inline(__always)
    public init(@Info _ info: () -> Self) {
        self.init(info())
    }
    
    @inlinable @inline(__always)
    public init(_ transform: (inout Self) -> Void) {
        self.init({ var info = Self(); transform(&info); return info }())
    }
    
    @inlinable @inline(__always)
    public init(_ many: @autoclosure () -> [Self]) {
        self.init(many().map(\.description))
    }
    
    @inlinable @inline(__always)
    public init(_ error: @autoclosure () -> any Error) {
        self.init([String(describing: error())])
    }
    
    @inlinable @inline(__always)
    public static func buildBlock(_ instances: Self...) -> Self {
        Self(instances)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func note(_ item: @autoclosure () -> Any) -> Self {
        self.init([String(describing: item())])
    }
    
    @inlinable @inline(__always)
    public static func mark(_ item: @autoclosure () -> Any) -> Self {
        Self(["« \(item()) »"])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var description: String {
        #if DEBUG
        self.content.joined(separator: Self.separator)
        #else
        Self.unknown
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    mutating func transform(_ transform: (inout [String]) -> Void) {
        #if DEBUG
        transform(&self.content)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public mutating func join(separator: @autoclosure () -> String = Self.separator) {
        self.transform({ $0 = [$0.joined(separator: separator())] })
    }
    
    @inlinable @inline(__always)
    public func joined(separator: @autoclosure () -> String = Self.separator) -> Self {
        Self({ $0.join(separator: separator()) })
    }
    
    @inlinable @inline(__always)
    public static func += (info: inout Self, other: @autoclosure () -> Self) {
        info.transform({ $0.append(other().description) })
    }
}
