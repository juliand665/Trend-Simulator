// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class PopularityGraph: GraphView {
	override func historyEntry(from simulation: Simulation) -> [Int : Double] {
		let totalCount = Double(simulation.people.count)
		let mapped = simulation.products.map {
			($0.id, Double($0.users.count) / totalCount)
		}
		return .init(uniqueKeysWithValues: mapped)
	}
	
	override func prepareForDrawing() {
		NSGraphicsContext.current!.shouldAntialias = false
	}
	
	override func draw(_ entry: [Int: Double], at x: CGFloat, width: CGFloat) {
		var y: CGFloat = 0
		for id in 0 ... entry.keys.max()! {
			guard let popularity = entry[id] else { continue }
			color(forID: id).setFill()
			let height = frame.height * CGFloat(popularity)
			NSRect(x: x, y: y, width: width, height: height).fill()
			y += height
		}
	}
}
