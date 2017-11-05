// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class PopularityGraph: GraphView {
	override func historyEntry(from simulation: Simulation) -> Entry {
		let totalCount = Double(simulation.people.count)
		let mapped = simulation.products.map {
			($0.id, Double($0.users.count) / totalCount)
		}
		return .init(uniqueKeysWithValues: mapped)
	}
	
	override func prepareForDrawing(in context: CGContext) {
		context.setShouldAntialias(false)
	}
	
	override func draw(_ entry: Entry, at x: CGFloat, width: CGFloat, height: CGFloat, in context: CGContext) {
		var y: CGFloat = 0
		for id in 0 ... entry.keys.max()! {
			guard let popularity = entry[id] else { continue }
			context.setFillColor(color(forID: id).cgColor)
			let heightDiff = height * CGFloat(popularity)
			context.fill(CGRect(x: x, y: y, width: width, height: heightDiff))
			y += heightDiff
		}
	}
}
