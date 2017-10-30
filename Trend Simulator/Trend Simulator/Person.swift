//  Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

class Person {
	unowned var simulation: Simulation
	weak var choice: Product?
	
	/// gives a bonus to the current product's quality over other products when comparing
	var loyalty: Double
	/// current marketing bonus by product
	var marketingStats: [Product: Double] = [:]
	
	/// fails if choice not specified and no people in simulation
	init(in simulation: Simulation, choosing choice: Product? = nil) {
		self.simulation = simulation
		loyalty = .randomValue(in: simulation.loyaltyRange)
		assert(choice != nil || !simulation.people.isEmpty,
		       "Chosen product must be manually specified for the first person!")
		choose(choice ?? simulation.people.randomElement()?.choice)
	}
	
	func choose(_ product: Product?) {
		let current = choice
		choice = product
		current?.removeUser(self)
		product?.addUser(self)
	}
	
	func biasedQuality(for product: Product) -> Double {
		let loyaltyBonus = product == choice ? loyalty : 0
		return product.quality * (1 + loyaltyBonus) + marketingStats[product, default: simulation.marketingBonusRange.max]
	}
	
	func tick() {
		guard let choice = choice else {
			print("No choice!")
			return
		}
		
		let bonus = marketingStats[choice, default: simulation.marketingBonusRange.max]
		marketingStats[choice] = max(simulation.marketingBonusRange.min, bonus - simulation.marketingBonusDecrease)
		
		// search for better products
		let currentQuality = biasedQuality(for: choice)
		// randomly select a product proportionally to how many users it has
		if let alternative = simulation.people.randomElement()?.choice,
			biasedQuality(for: alternative) > currentQuality {
			choose(alternative)
		} else if simulation.newProductChance.isFulfilled() {
			// create own product, for lack of a better choice
			let newQuality = choice.quality
			choose(simulation.addProduct(ofQuality: newQuality))
		}
	}
}

extension Person: Equatable, Hashable {
	static func ==(l: Person, r: Person) -> Bool {
		return l === r
	}
	
	var hashValue: Int {
		return ObjectIdentifier(self).hashValue
	}
}
