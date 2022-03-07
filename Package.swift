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
                "DiffableTextViews_iOS"]),
        //=--------------------------------------=
        // MARK: DiffableTextViews_iOS
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews_iOS",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViews_iOSTests",
            dependencies: ["DiffableTextViews_iOS", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextStyles
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles",
            dependencies: [
                "DiffableTextKit",
                "DiffableTextStyles_Numeric",
                "DiffableTextStyles_Pattern"]),
        //=--------------------------------------=
        // MARK: DiffableTextStyles_Numeric
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles_Numeric",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextStyles_NumericTests",
            dependencies: ["DiffableTextStyles_Numeric", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextStyles_Pattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles_Pattern",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextStyles_PatternTests",
            dependencies: ["DiffableTextStyles_Pattern", "XCTestSupport"]),
        //=--------------------------------------=
        // MARK: DiffableTextKit
        //=--------------------------------------=
        .target(name: "DiffableTextKit"),
        //=--------------------------------------=
        // MARK: XCTestSupport
        //=--------------------------------------=
        .target(name: "XCTestSupport", path: "Tests/XCTestSupport")
    ]
)
