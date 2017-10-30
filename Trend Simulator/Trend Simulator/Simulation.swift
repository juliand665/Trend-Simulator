//  Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

typealias Range = (min: Double, max: Double)

class Simulation {
	/// how many times the simulation ticks before printing its details again
	let ticksPerLog = 10
	
	/// total product improvement per tick, spread over all products
	let productImprovement = 0.01
	
	/// how likely a person is to create a new product when he can't find a better one
	let newProductChance = RandomChance(of: 0.0001)
	/// how much better a new product is than the one the creator is currently using
	let newProductQualityBonus = 1
	
	/// how likely it is that a new person is added to the simulation (each tick)
	let newPersonChance = RandomChance(of: 0.01)
	/// how loyal a user can be; loyalty is chosen at random from this range
	let loyaltyRange: Range = (0.0, 0.1)
	/// upper and lower bound for the user's bias in the perception of the product's quality (as through marketing). starts out as the upper bound when first looking at a product
	let marketingBonusRange: Range = (0.0, 10.0)
	/// how much the bias decreases per tick as you use the product (down to the lower bound of `qualityBiasRange`)
	let marketingBonusDecrease = 0.01
	
	private(set) var currentTick = 0
	private(set) var products: Set<Product> = []
	private(set) var people: Set<Person> = []
	private var highestProductID = 0
	
	init() {
		addPerson(choosing: addProduct())
	}
	
	@discardableResult func addProduct(ofQuality quality: Double = 0) -> Product {
		let product = Product(in: self, withID: highestProductID, ofQuality: quality)
		highestProductID += 1
		products.insert(product)
		return product
	}
	
	func remove(_ product: Product) {
		products.remove(product)
	}
	
	func remove(_ person: Person) {
		people.remove(person)
	}
	
	@discardableResult func addPerson(choosing choice: Product) -> Person {
		let person = Person(in: self, choosing: choice)
		people.insert(person)
		return person
	}
	
	func run() {
		while true {
			log()
			for _ in 1...ticksPerLog {
				tick()
			}
		}
	}
	
	func tick() {
		currentTick += 1
		
		for person in people {
			person.tick()
		}
		
		for product in products {
			product.tick()
		}
		
		if newPersonChance.isFulfilled() {
			people.insert(Person(in: self))
		}
	}
	
	func log() {
		print("""
			
			tick \(currentTick)
			—————
			
			\(people.count) people
			\(products.count) active products (\(highestProductID) total)
			
			Top products:
			""")
		let topProducts = products.sorted { (l, r) -> Bool in
			l.users.count > r.users.count
		}
		for rank in 1...5 {
			let productDesc = topProducts.element(at: rank - 1)?.description ?? "-"
			print("\(rank). \(productDesc)")
		}
		print("""
			
			Best products:
			""")
		let bestProducts = products.sorted { (l, r) -> Bool in
			l.quality > r.quality
		}
		for rank in 1...5 {
			let productDesc = bestProducts.element(at: rank - 1)?.description ?? "-"
			print("\(rank). \(productDesc)")
		}
	}
}
