////=----------------------------------------------------------------------------=
//// This source file is part of the DiffableTextViews open source project.
////
//// Copyright (c) 2022 Oscar Byström Ericsson
//// Licensed under Apache License, Version 2.0
////
//// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
////=----------------------------------------------------------------------------=
//
//import DiffableTextKit
//import Foundation
//
////*============================================================================*
//// MARK: * Standard x Style
////*============================================================================*
//
//public struct _Standard_Style<Format: _Format_Standard>: _Internal {    
//    public typealias Cache = _Standard_Cache<Format>
//    public typealias Value = Format.FormatInput
//    
//    //=------------------------------------------------------------------------=
//    // MARK: State
//    //=------------------------------------------------------------------------=
//    
//    @usableFromInline var key: Cache.Key
//    @usableFromInline var bounds: NumberTextBounds<Input>?
//    @usableFromInline var precision: NumberTextPrecision<Input>?
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Initializers
//    //=------------------------------------------------------------------------=
//    
//    @inlinable init(locale: Locale) {
//        self.key = .init(locale: locale)
//    }
//}
