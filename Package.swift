// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: -

struct Source {
    let name: String
    
    var tests: String {
        name.appending("Tests")
    }
    
    var dependency: Target.Dependency {
        .init(stringLiteral: name)
    }
}

// MARK: -

let TextFields = Source(name: "TextFields")
let Loops = Source(name: "Loops")

// MARK: -

let package = Package(
    name: "TextFields",
    products: [
        .library(
            name: TextFields.name,
            targets: [TextFields.name]),
        .library(
            name: Loops.name,
            targets: [Loops.name])
    ],
    targets: [
        .target(name: TextFields.name),
        .target(name: Loops.name),
        .target(name: "Trash"),
    ]
)
