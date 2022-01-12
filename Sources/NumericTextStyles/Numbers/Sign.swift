//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Sign
//*============================================================================*

/// A system representation of a sign.
@usableFromInline enum Sign: Character, Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case positive = "+"
    case negative = "-"
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .positive
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func toggle() {
        switch self {
        case .positive: self = .negative
        case .negative: self = .positive
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters, in region: Region) {
        region.signsInLocale[self]?.write(to: &characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sign - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Sign: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        switch self {
        case .positive: return "positive"
        case .negative: return "negative"
        }
    }
}
