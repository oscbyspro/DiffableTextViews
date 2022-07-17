//*============================================================================*
// MARK: * Value x Optional
//*============================================================================*

extension Optional: _Value where Wrapped: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isOptional: Bool { true }
    @inlinable public static var isUnsigned: Bool { Wrapped.isUnsigned }
    @inlinable public static var isInteger:  Bool { Wrapped.isInteger  }
}
