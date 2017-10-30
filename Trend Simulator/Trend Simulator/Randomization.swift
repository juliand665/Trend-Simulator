//  Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

extension Int {
	static func randomValue(lessThan bound: Int) -> Int {
		return Int(arc4random_uniform(UInt32(bound)))
	}
}

extension FloatingPoint {
	static func randomValue(in bounds: (min: Self, max: Self)? = nil) -> Self {
		let random = Self(arc4random()) / Self(UInt32.max)
		if let (min, max) = bounds {
			return min + (max - min) * random
		} else {
			return random
		}
	}
}

struct RandomChance {
	var probability: Double
	
	init(of probability: Double) {
		self.probability = probability
	}
	
	func isFulfilled() -> Bool {
		return .randomValue() < probability
	}
}

extension Set {
	func randomElement() -> Element? {
		let index = self.index(startIndex, offsetBy: .randomValue(lessThan: count))
		return count > 0 ? self[index] : nil
	}
}
