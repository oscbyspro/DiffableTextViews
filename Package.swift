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
// MARK: DiffableTextViews
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
        // DiffableTextViews
        //=--------------------------------------=
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews"]),
    ],
    targets: [
        //=--------------------------------------=
        // 5 - DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: [
                "DiffableTextStyles",
                "DiffableTextViewsXUIKit"]),
        //=--------------------------------------=
        // 4 - DiffableTextStyles
        //=--------------------------------------=
        .target(
            name: "DiffableTextStyles",
            dependencies: [
                "DiffableTextStylesXNumber",
                "DiffableTextStylesXPattern",
                "DiffableTextStylesXWrapper"]),
        //=--------------------------------------=
        // 3 - DiffableTextStylesXNumber
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXNumber",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXNumberTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXNumber"]),
        //=--------------------------------------=
        // 3 - DiffableTextStylesXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXPattern",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXPatternTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXPattern"]),
        //=--------------------------------------=
        // 3 - DiffableTextStylesXWrapper
        //=--------------------------------------=
        .target(
            name: "DiffableTextStylesXWrapper",
            dependencies: ["DiffableTextKit", "DiffableTextViewsXUIKit"]),
        .testTarget(
            name: "DiffableTextStylesXWrapperTests",
            dependencies: ["DiffableTestKit", "DiffableTextStylesXWrapper"]),
        //=--------------------------------------=
        // 2 - DiffableTextViewsXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextViewsXUIKit",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextViewsXUIKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextViewsXUIKit"]),
        //=--------------------------------------=
        // 1 - DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: ["DiffableTextKitXUIKit"]),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextKit"]),
        //=--------------------------------------=
        // 0 - DiffableTextKitXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXUIKit",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitXUIKitTests",
            dependencies: ["DiffableTestKit", "DiffableTextKitXUIKit"]),
        //=--------------------------------------=
        // T - DiffableTestKit
        //=--------------------------------------=
        .target(name: "DiffableTestKit", path: "Tests/DiffableTestKit")
    ]
)
