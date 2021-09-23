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

let OBETextFields = Source(name: "OBETextFields")

// MARK: -

let package = Package(
    name: "OBETextFields",
    products: [
        .library(
            name: OBETextFields.name,
            targets: [OBETextFields.name]),
    ],
    targets: [
        .target(
            name: OBETextFields.name,
            dependencies: []),
        .testTarget(
            name: OBETextFields.tests,
            dependencies: [OBETextFields.dependency]),
    ]
)
