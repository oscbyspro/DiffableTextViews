//
//  EquatableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-29.
//

//*============================================================================*
// MARK: * EquatableTextStyle
//*============================================================================*

public struct EquatableTextStyle<Style: DiffableTextStyle>: WrapperTextStyle {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let equatable: AnyHashable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(style: Style, equatable: AnyHashable) {
        self.style = style
        self.equatable = equatable
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equatable == rhs.equatable
    }
}

//=----------------------------------------------------------------------------=
// MARK: EquatableTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension EquatableTextStyle: UIKitWrapper, UIKitDiffableTextStyle where Style: UIKitDiffableTextStyle { }

#endif

//*============================================================================*
// MARK: * DiffableTextStyle x EquatableTextStyle
//*============================================================================*

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Binds the style's identity to zero.
    @inlinable func constant() -> EquatableTextStyle<Self> {
        EquatableTextStyle(style: self, equatable: 0)
    }
    
    /// Binds the style's identity to the value.
    @inlinable func equatable<ID: Hashable>(_ value: ID) -> EquatableTextStyle<Self> {
        EquatableTextStyle(style: self, equatable: value)
    }
}
