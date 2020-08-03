// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjLib",
    products: [
        .library(name: "ProjLib", targets: ["ProjLib"])
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(name: "proj",
                       pkgConfig: "proj",
                       providers: [.brew(["proj"])]),
        .target(name: "ProjLib", dependencies: ["proj"]),
        .target(name: "example", dependencies: [.target(name: "ProjLib")])
    ]
)
