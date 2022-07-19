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
// MARK: * Token
//*============================================================================*

/// A UTF-8 encoded ASCII character.
@usableFromInline protocol _Token: CaseIterable, CustomStringConvertible, Hashable {
    associatedtype Enumeration: CaseIterable, RawRepresentable where Enumeration.RawValue == UInt8

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: UInt8 { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ enumeration: Enumeration)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable func standard(_ formatter: NumberFormatter) -> Character!

    @inlinable func currency(_ formatter: NumberFormatter) -> Character!
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Token {
    
    //=------------------------------------------------------------------------=
    // MARK: Enumeration
    //=------------------------------------------------------------------------=
    
    @inlinable var enumeration: Enumeration {
        Enumeration(rawValue: rawValue)!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Unicodeable
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
    
    @inlinable var character: Character {
        Character(unicode)
    }
    
    @inlinable var description: String {
        String(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        standard(formatter)
    }
}

//*============================================================================*
// MARK: * Token x Collection
//*============================================================================*

/// Multiple UTF-8 encoded ASCII characters.
@usableFromInline protocol _Tokens: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Tokens {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        String(bytes: rawValue, encoding: .utf8)!
    }
}
