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
        // X - DiffableTextViews
        //=--------------------------------------=
        .target(
            name: "DiffableTextViews",
            dependencies: [
                "DiffableTextKitXUIKit",
                "DiffableTextKitXNumber",
                "DiffableTextKitXPattern"]),
        //=--------------------------------------=
        // 2 - DiffableTextKitXNumber
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXNumber",
            dependencies: [
                "DiffableTextKit",
                "DiffableTextKitXUIKit"]),
        .testTarget(
            name: "DiffableTextKitXNumberTests",
            dependencies: ["DiffableTextKitXNumber"]),
        //=--------------------------------------=
        // 2 - DiffableTextKitXPattern
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXPattern",
            dependencies: [
                "DiffableTextKit",
                "DiffableTextKitXUIKit"]),
        .testTarget(
            name: "DiffableTextKitXPatternTests",
            dependencies: ["DiffableTextKitXPattern"]),
        //=--------------------------------------=
        // 1 - DiffableTextKitXUIKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKitXUIKit",
            dependencies: ["DiffableTextKit"]),
        .testTarget(
            name: "DiffableTextKitXUIKitTests",
            dependencies: ["DiffableTextKitXUIKit"]),
        //=--------------------------------------=
        // 0 - DiffableTextKit
        //=--------------------------------------=
        .target(
            name: "DiffableTextKit",
            dependencies: []),
        .testTarget(
            name: "DiffableTextKitTests",
            dependencies: ["DiffableTextKit"]),
    ]
)
