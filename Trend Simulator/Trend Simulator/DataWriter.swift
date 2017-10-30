// Copyright © 2017 Julian Dunskus. All rights reserved.

import AppKit

class DataWriter {
	var popularityFile: FileHandle
	var qualityFile: FileHandle
	unowned var simulation: Simulation
	
	init(for simulation: Simulation) throws {
		self.simulation = simulation
		
		let desktop = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
		assert(FileManager.default.createFile(atPath: desktop.appendingPathComponent("popularity.csv").path, contents: Data()))
		popularityFile = try FileHandle(forWritingTo: desktop.appendingPathComponent("popularity.csv"))
		assert(FileManager.default.createFile(atPath: desktop.appendingPathComponent("quality.csv").path, contents: Data()))
		qualityFile = try FileHandle(forWritingTo: desktop.appendingPathComponent("quality.csv"))
	}
	
	func writeData() {
		var popularity = "\(simulation.currentTick)"
		var quality = popularity
		
		let highestID = simulation.products.max()!.id
		var products = [Product?](repeating: nil, count: highestID + 1)
		for product in simulation.products {
			products[product.id] = product
		}
		
		let total = Double(simulation.people.count)
		for product in products {
			if let product = product {
				popularity.append(", \(Double(product.users.count) / total)")
				quality.append(", \(product.quality)")
			} else {
				popularity.append(", ")
				quality.append(", ")
			}
		}
		popularity.append("\n")
		quality.append("\n")
		popularityFile.write(popularity.data(using: .utf8)!)
		qualityFile.write(quality.data(using: .utf8)!)
	}
}
