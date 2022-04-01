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
        // MARK: 5 - DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: [
                "DiffableTextStyles",
                "DiffableTextViewsXiOS"]),
        //=--------------------------------------=
        // MARK: 4 - DiffableTextStyles
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles",
            dependencies: [
                "DiffableTextStylesXNumeric",
                "DiffableTextStylesXPattern",
                "DiffableTextStylesXWrapper"]),
        //=--------------------------------------=
        // MARK: 3 - DiffableTextStylesXNumeric
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXNumeric",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXiOS"]),
        .testTarget(
            name: "DiffableTextStylesXNumericTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXNumeric"]),
        //=--------------------------------------=
        // MARK: 3 - DiffableTextStylesXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXPattern",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXiOS"]),
        .testTarget(
            name: "DiffableTextStylesXPatternTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // MARK: 3 - DiffableTextStylesXWrapper
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXWrapper",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXiOS"]),
        //=--------------------------------------=
        // MARK: 2 - DiffableTextViewsXiOS
        //=--------------------------------------=
        .target(
            name: "DiffableTextViewsXiOS",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViewsXiOSTests",
            dependencies: ["DiffableTestKit", "DiffableTextViewsXiOS"]),
        //=--------------------------------------=
        // MARK: 1 - DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: ["DiffableTextKitXiOS"]),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTextKit", "DiffableTestKit"]),
        //=--------------------------------------=
        // MARK: 0 - DiffableTextKitXiOS
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXiOS",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitXiOSTests",
            dependencies: ["DiffableTestKit"]),
        //=--------------------------------------=
        // MARK: T - DiffableTestKit
        //=--------------------------------------=
        .target(name: "DiffableTestKit", path: "Tests/DiffableTestKit")
    ]
)
