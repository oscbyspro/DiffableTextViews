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
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
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
                "DiffableTextViewsXUIKit"]),
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
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXNumericTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXNumeric"]),
        //=--------------------------------------=
        // MARK: 3 - DiffableTextStylesXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXPattern",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXPatternTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // MARK: 3 - DiffableTextStylesXWrapper
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXWrapper",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXWrapperTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXWrapper"]),
        //=--------------------------------------=
        // MARK: 2 - DiffableTextViewsXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextViewsXUIKit",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViewsXUIKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextViewsXUIKit"]),
        //=--------------------------------------=
        // MARK: 1 - DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: ["DiffableTextKitXUIKit"]),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextKit"]),
        //=--------------------------------------=
        // MARK: 0 - DiffableTextKitXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXUIKit",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitXUIKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextKitXUIKit"]),
        //=--------------------------------------=
        // MARK: T - DiffableTestKit
        //=--------------------------------------=
        .target(name: "DiffableTestKit", path: "Tests/DiffableTestKit")
    ]
)
