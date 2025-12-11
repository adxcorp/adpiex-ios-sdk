// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "spm-adpie-x-framework",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "spm-adpie-x-framework",
            targets: [
                "spm-adpie-x-framework-target",
            ]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "adpie-x-binary-target",
            path: "frmAdPieX/AdPieXFramework.xcframework"
        ),
        .target(
            name: "spm-adpie-x-framework-target",
            dependencies: [
                "adpie-x-binary-target",
            ],
            path: "frmAdPieX/Dependency",
            exclude: [
                "../../Samples/ObjcAdPieX",
                "../../Samples/SwiftAdPieX"
            ]
        ),
    ]
)
