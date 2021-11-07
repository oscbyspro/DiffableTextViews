// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiffableTextViews",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DiffableTextViews",
            targets: ["DiffableTextViews", "NumericTextStyleKit"]),
    ],
    targets: [
        .target(
            name: "DiffableTextViews",
            dependencies: []),
        .testTarget(
            name: "DiffableTextViewsTests",
            dependencies: ["DiffableTextViews"]),
        // --------------------------------- //
        .target(
            name: "NumericTextStyleKit",
            dependencies: ["DiffableTextViews"]),
    ]
)
