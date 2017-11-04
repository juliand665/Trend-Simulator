// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class QualityGraph: GraphView {
	var paths: [Int: NSBezierPath]!
	var highestQuality: CGFloat = 0
	var lowestQuality: CGFloat = 0
	
	override func historyEntry(from simulation: Simulation) -> [Int : Double] {
		return .init(uniqueKeysWithValues: simulation.products.map {
			($0.id, $0.quality)
		})
	}
	
	override func prepareForDrawing() {
		NSColor.white.setFill()
		frame.fill()
		NSGraphicsContext.current!.shouldAntialias = true
		NSBezierPath.defaultLineWidth = 4
		paths = [:]
		
		highestQuality = CGFloat(history.flatMap { $0.values.max() }.max() ?? 0)
		lowestQuality = CGFloat(history.flatMap { $0.values.min() }.min() ?? 0)
	}
	
	override func draw(_ entry: [Int: Double], at x: CGFloat, width: CGFloat) {
		func point(forQuality quality: Double) -> CGPoint {
			let height = frame.height * (CGFloat(quality) - lowestQuality) / (highestQuality - lowestQuality)
			return CGPoint(x: x + width / 2, y: height)
		}
		
		for (id, path) in paths {
			if let quality = entry[id] {
				path.line(to: point(forQuality: quality))
			}
		}
		
		for (id, quality) in entry where paths[id] == nil {
			let path = NSBezierPath()
			path.move(to: point(forQuality: quality))
			paths[id] = path
		}
	}
	
	override func finalizeDrawing() {
		for (id, path) in paths {
			color(forID: id).set()
			path.stroke()
		}
		paths = nil
	}
}
