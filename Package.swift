// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RCKit",
    platforms: [.iOS(SupportedPlatform.IOSVersion.v9)],
    products: [.library(name: "RCKit", targets: ["RCKit"])],
    dependencies:[
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/Swinject/Swinject",  from: "2.7.1"),
    ],
    targets: [
        .target(name: "RCKit", dependencies: ["RxSwift", "RxCocoa", "Swinject"])
    ]
)


