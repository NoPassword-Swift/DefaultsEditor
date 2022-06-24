// swift-tools-version: 5.5

import PackageDescription

let package = Package(
	name: "DefaultsEditor",
	platforms: [
		.iOS("15.0"),
		.macOS("12.0"),
	],
	products: [
		.library(
			name: "DefaultsEditor",
			targets: ["DefaultsEditor"]),
	],
	dependencies: [
		.package(url: "https://github.com/NoPassword-Swift/StaticTable.git", "0.0.1"..<"0.1.0"),
	],
	targets: [
		.target(
			name: "DefaultsEditor",
			dependencies: [
				"StaticTable",
			]),
	]
)
