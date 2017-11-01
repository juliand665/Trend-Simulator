// Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

class Logger: Outputter {
	func output(_ simulation: Simulation) {
		print("""
			
			tick \(simulation.currentTick)
			—————
			
			\(simulation.people.count) people
			\(simulation.products.count) active products (\(simulation.highestProductID) total)
			
			Top products:
			""")
		let topProducts = simulation.products.sorted { (l, r) -> Bool in
			l.users.count > r.users.count
		}
		for rank in 1...5 {
			let productDesc = topProducts.element(at: rank - 1)?.description ?? "-"
			print("\(rank). \(productDesc)")
		}
		print("""
			
			Best products:
			""")
		let bestProducts = simulation.products.sorted { (l, r) -> Bool in
			l.quality > r.quality
		}
		for rank in 1...5 {
			let productDesc = bestProducts.element(at: rank - 1)?.description ?? "-"
			print("\(rank). \(productDesc)")
		}
	}
}
