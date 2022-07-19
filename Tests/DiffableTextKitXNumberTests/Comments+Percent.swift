////=----------------------------------------------------------------------------=
//// This source file is part of the DiffableTextViews open source project.
////
//// Copyright (c) 2022 Oscar Byström Ericsson
//// Licensed under Apache License, Version 2.0
////
//// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
////=----------------------------------------------------------------------------=
//
//#if DEBUG
//
//@testable import DiffableTextKitXNumber
//
//import XCTest
//
////*============================================================================*
//// MARK: * Comments x Percent
////*============================================================================*
//
//final class CommentsOnPercent: XCTestCase {
//    
//    //=------------------------------------------------------------------------=
//    // MARK: Tests
//    //=------------------------------------------------------------------------=
//    
//    func testPercentLabelsAreAlwaysVirtual() throws {
//        //=--------------------------------------=
//        // Locales
//        //=--------------------------------------=
//        for interpreter in standards {
//            func nonvirtual(_ character: Character) -> Bool {
//                   interpreter.components.signs[     character] != nil
//                || interpreter.components.digits[    character] != nil
//                || interpreter.components.separators[character] == Separator.fraction
//            }
//            
//            let zero = IntegerFormatStyle<Int>.Percent(locale: interpreter.id.locale).format(0)
//            XCTAssert(zero.count(where: nonvirtual) == 1,  "\(zero), \(interpreter.id.locale)")
//        }
//    }
//}
//
//#endif
