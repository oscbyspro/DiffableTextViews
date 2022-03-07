// swift-tools-version:5.5
//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import PackageDescription

//*============================================================================*
// MARK: * DiffableTextViews
//*============================================================================*

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        //=--------------------------------------=
        // MARK: DiffableTextViews
        //=--------------------------------------=
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews"]),
    ],
    targets: [
        //=--------------------------------------=
        // MARK: DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: [
                "DiffableTextStyles",
                "DiffableTextViewsXiOS"]),
        //=--------------------------------------=
        // MARK: DiffableTextViewsXiOS
        //=--------------------------------------=
        .target(
            name: "DiffableTextViewsXiOS",
            dependencies: ["DiffableTextStyles", "DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViewsTestsXiOS",
            dependencies: ["DiffableTextViewsXiOS", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextStyles
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles",
            dependencies: [
                "DiffableTextKit",
                "DiffableTextStylesXNumeric",
                "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // MARK: DiffableTextStylesXNumeric
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXNumeric",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextStylesTestsXNumeric",
            dependencies: ["DiffableTextStylesXNumeric", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextStylesXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXPattern",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextStylesTestsXPattern",
            dependencies: ["DiffableTextStylesXPattern", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTextKit", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: XCTestSupport
        //=--------------------------------------=
        .target(name: "XCTestSupport", path: "Tests/XCTestSupport")
    ]
)
