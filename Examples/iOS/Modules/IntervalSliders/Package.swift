// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//*============================================================================*
// MARK: * IntervalSliders
//*============================================================================*

let package = Package(
    name: "IntervalSliders",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        //=--------------------------------------=
        // MARK: IntervalSliders
        //=--------------------------------------=
        .library(
            name: "IntervalSliders",
            targets: ["IntervalSliders"])
    ],
    targets: [
        //=--------------------------------------=
        // MARK: IntervalSliders
        //=--------------------------------------=
        .target(name: "IntervalSliders"),
    ]
)
