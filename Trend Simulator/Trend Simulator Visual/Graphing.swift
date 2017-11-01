// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class GraphView: NSView, Outputter {
	let historyMax = 32
	private(set) var history: [[Int: Double]] = []
	
	func output(_ simulation: Simulation) {
		history.append(historyEntry(from: simulation))
		if history.count > historyMax {
			history.removeFirst()
		}
		
		DispatchQueue.main.async { 
			self.needsDisplay = true
		}
	}
	
	func historyEntry(from simulation: Simulation) -> [Int: Double] {
		fatalError("historyEntry(from:) must be overridden!")
	}
	
	override func draw(_ dirtyRect: NSRect) {
		NSColor.white.setFill()
		frame.fill()
		
		let width = frame.width / CGFloat(history.count)
		for (index, entry) in history.enumerated() {
			let x = CGFloat(index) * width
			guard x + width > dirtyRect.minX, x < dirtyRect.maxX else { continue }
			draw(entry, at: x, width: width)
		}
	}
	
	func draw(_ entry: [Int: Double], at x: CGFloat, width: CGFloat) {
		fatalError("draw(_:x:width:) must be overridden!")
	}
	
	func color(forID id: Int) -> NSColor {
		let hueSteps = 32
		let brightnessSteps = 8
		let hue = CGFloat(id % 32) / CGFloat(hueSteps)
		let brightness = 1 - CGFloat((id / hueSteps) % brightnessSteps) / CGFloat(brightnessSteps)
		return NSColor(hue: hue, saturation: 0.9, brightness: brightness, alpha: 1)
	}
}

class PopularityGraph: GraphView {
	override func historyEntry(from simulation: Simulation) -> [Int : Double] {
		let totalCount = Double(simulation.people.count)
		let mapped = simulation.products.map {
			($0.id, Double($0.users.count) / totalCount)
		}
		return .init(uniqueKeysWithValues: mapped)
	}
	
	override func draw(_ entry: [Int : Double], at x: CGFloat, width: CGFloat) {
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

class QualityGraph: GraphView {
	var highestQuality: CGFloat = 0
	
	override func historyEntry(from simulation: Simulation) -> [Int : Double] {
		return .init(uniqueKeysWithValues: simulation.products.map {
			highestQuality = max(highestQuality, CGFloat($0.quality))
			return ($0.id, $0.quality)
		})
	}
	
	override func draw(_ entry: [Int : Double], at x: CGFloat, width: CGFloat) {
		let highest = entry.max { $0.value < $1.value }!
		
		color(forID: highest.key).setFill()
		let height = frame.height * CGFloat(highest.value) / highestQuality
		NSRect(x: x, y: 0, width: width, height: height).fill()
		
//		let sorted = entry.sorted { (l, r) -> Bool in
//			l.value > r.value
//		}
//		
//		for (id, quality) in sorted {
//			color(forID: id).setFill()
//			let height = frame.height * CGFloat(quality) / highestQuality
//			NSRect(x: x, y: 0, width: width, height: height).fill()
//		}
	}
}
