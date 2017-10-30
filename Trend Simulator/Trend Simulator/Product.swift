//  Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

class Product {
	unowned var simulation: Simulation
	
	let id: Int
	private(set) var quality: Double // >= 0
	private(set) var users: Set<Person> = []
	
	init(in simulation: Simulation, withID id: Int, ofQuality quality: Double) {
		self.simulation = simulation
		self.id = id
		self.quality = quality
	}
	
	/// call after choosing this product
	func addUser(_ user: Person) {
		assert(user.choice == self)
		users.insert(user)
	}
	
	/// call after switching to a different product
	func removeUser(_ user: Person) {
		users.remove(user)
	}
	
	func tick() {
		guard !users.isEmpty else {
			simulation.remove(self)
			return
		}
		quality += simulation.productImprovement * Double(users.count) / Double(simulation.people.count)
	}
}

extension Product: Equatable, Hashable {
	static func ==(l: Product, r: Product) -> Bool {
		return l === r
	}
	
	var hashValue: Int {
		return ObjectIdentifier(self).hashValue
	}
}

extension Product: Comparable {
	static func <(l: Product, r: Product) -> Bool {
		return l.id < r.id
	}
}

let formatter: NumberFormatter = {
	let formatter = NumberFormatter()
	formatter.minimumIntegerDigits = 1
	formatter.minimumFractionDigits = 2
	formatter.maximumFractionDigits = 2
	return formatter
}()

extension Product: CustomStringConvertible {
	var description: String {
		let qualityDesc = formatter.string(from: quality as NSNumber) ?? "N/A"
		let popularity = 100 * Double(users.count) / Double(simulation.people.count)
		let popularityDesc = formatter.string(from: popularity as NSNumber) ?? "N/A"
		return "Product #\(id)     \t| quality \(qualityDesc)     \t| \(users.count) users (\(popularityDesc)%)"
	}
}
