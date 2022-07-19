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

/// A single ASCII-encoded character.
@usableFromInline protocol _Token: CaseIterable, CustomStringConvertible, Hashable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: UInt8 { get }
    
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
    // MARK: Unicodeable
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(ascii)
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

/// A collection of ASCII-encoded characters.
@usableFromInline protocol _Tokens: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Tokens {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        String(bytes: ascii, encoding: .ascii)!
    }
}
