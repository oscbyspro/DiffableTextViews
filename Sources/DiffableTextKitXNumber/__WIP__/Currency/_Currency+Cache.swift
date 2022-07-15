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
//// MARK: * Currency x Cache
////*============================================================================*
//
//public struct _Currency_Cache<Format: _Format_Currency>: _Cache_Internal {
//    public typealias Style = _Currency_Style<Format>
//        
//    //=------------------------------------------------------------------------=
//    // MARK: State
//    //=------------------------------------------------------------------------=
//    
//    @usableFromInline let key: _Currency_Key
//    @usableFromInline let adapter: _Adapter<Format>
//    @usableFromInline let preferences: Preferences<Input>
//    @usableFromInline let interpreter: NumberTextReader
//    @usableFromInline let adjustments: _Currency_Label?
//
//    //=------------------------------------------------------------------------=
//    // MARK: Initializers
//    //=------------------------------------------------------------------------=
//    
//    @inlinable init(_ key: _Currency_Key) {
//        self.key = key
//        self.adapter = .init(code: key.code, locale: key.locale)
//        //=--------------------------------------=
//        // Formatter
//        //=--------------------------------------=
//        let formatter = NumberFormatter()
//        formatter.locale = key.locale
//        formatter.currencyCode = key.code
//        //=--------------------------------------=
//        // Formatter x None
//        //=--------------------------------------=
//        assert(formatter.numberStyle == .none)
//        self.interpreter = .currency(formatter)
//        //=--------------------------------------=
//        // Formatter x Currency
//        //=--------------------------------------=
//        formatter.numberStyle = .currency
//        self.preferences = .currency(formatter)
//        //=--------------------------------------=
//        // Formatter x Currency x Fractionless
//        //=--------------------------------------=
//        formatter.maximumFractionDigits = .zero
//        self.adjustments = .init(formatter, interpreter.components)
//    }
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Utilities
//    //=------------------------------------------------------------------------=
//    
//    @inlinable func snapshot(_ characters: String) -> Snapshot {
//        var snapshot = Snapshot(characters, as: interpreter.attributes.map)
//        adjustments?.autocorrect(&snapshot)
//        return snapshot
//    }
//}
