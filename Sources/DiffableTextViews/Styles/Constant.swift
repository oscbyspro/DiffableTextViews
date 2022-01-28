//
//  Constant.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-28.
//

//*============================================================================*
// MARK: * Constant
//*============================================================================*

public final class Constant<Style: DiffableTextStyle>: DiffableTextStyle {
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline let style: Style

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    init(style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func showcase(value: Value) -> String {
        style.showcase(value: value)
    }
    
    @inlinable @inline(__always)
    public func editable(value: Value) -> Commit<Value> {
        style.editable(value: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func merge(request: Request) throws -> Commit<Value> {
        try style.merge(request: request)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Constant, rhs: Constant) -> Bool { true }
}

//=----------------------------------------------------------------------------=
// MARK: Constant - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension Constant: UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x Constant
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A promise that the style will remain unchanged between view updates.
    ///
    /// Use this only when you know that the style is constant.
    ///
    /// - Note: It is a reference type, so it may be cached for further optimization.
    ///
    @inlinable @inline(__always)
    public func constant() -> Constant<Self> { Constant(style: self) }
}
