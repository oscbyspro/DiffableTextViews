////=----------------------------------------------------------------------------=
//// This source file is part of the DiffableTextViews open source project.
////
//// Copyright (c) 2022 Oscar Byström Ericsson
//// Licensed under Apache License, Version 2.0
////
//// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
////=----------------------------------------------------------------------------=
//
//import Foundation
//
////*============================================================================*
//// MARK: * Standard x Cache
////*============================================================================*
//
//public struct _Standard_Cache<Format: _Format_Standard>: _Cache_Internal {
//    public typealias Style = _Standard_Style<Format>
//    public typealias Value = Format.FormatInput
//    
//    //=------------------------------------------------------------------------=
//    // MARK: State
//    //=------------------------------------------------------------------------=
//
//    @usableFromInline var key: _Standard_Key
//    @usableFromInline let adapter: _Adapter<Format>
//    @usableFromInline let preferences: Preferences<Value>
//    @usableFromInline let interpreter: NumberTextReader
//
//    //=------------------------------------------------------------------------=
//    // MARK: Initializers
//    //=------------------------------------------------------------------------=
//
//    @inlinable init(_ key: _Standard_Key) {
//        self.key = key
//        
//        self.adapter = .init(locale: key.locale)
//        self.preferences = .standard()
//        //=--------------------------------------=
//        // Formatter
//        //=--------------------------------------=
//        let formatter = NumberFormatter()
//        formatter.locale = key.locale
//        //=--------------------------------------=
//        // Formatter x None
//        //=--------------------------------------=
//        assert(formatter.numberStyle == .none)
//        self.interpreter = .standard(formatter)
//    }
//}
