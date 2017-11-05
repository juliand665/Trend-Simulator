// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class QualityGraph: GraphView {
	weak var maxQualityLabel: NSTextField!
	weak var minQualityLabel: NSTextField!
	
	override func historyEntry(from simulation: Simulation) -> Entry {
		return .init(uniqueKeysWithValues: simulation.products.map {
			($0.id, $0.quality)
		})
	}
	
	let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.minimumFractionDigits = 1
		formatter.maximumFractionDigits = 1
		return formatter
	}()
	
	override func draw<History>(_ history: History, in context: CGContext, height: CGFloat) where History: Collection, History.Element == GraphView.Entry, History.IndexDistance == Int {
		let max = CGFloat(history.flatMap { $0.values.max() }.max() ?? 0)
		let min = CGFloat(history.flatMap { $0.values.min() }.min() ?? 0)
		
		maxQualityLabel.stringValue = formatter.string(from: max as NSNumber)!
		minQualityLabel.stringValue = formatter.string(from: min as NSNumber)!
		
		var paths: [Int: [CGPoint]] = [:]
		
		var x: CGFloat = 0.5
		for entry in history {
			for (id, quality) in entry {
				let y = height * (CGFloat(quality) - min) / (max - min)
				let point = CGPoint(x: x, y: y)
				paths[id, default: []].append(point)
			}
			x += 1
		}
		
		context.setShouldAntialias(true)
		context.setLineWidth(height / (max - min) / 4)
		context.setLineCap(.round)
		context.setLineJoin(.round)
		
		for (id, path) in paths {
			context.setStrokeColor(color(forID: id).cgColor)
			context.move(to: path.first!)
			path.dropFirst().forEach(context.addLine)
			context.strokePath()
		}
	}
}
