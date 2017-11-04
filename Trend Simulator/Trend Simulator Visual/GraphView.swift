// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class GraphView: NSView, Outputter {
	let historyMax = 128
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
		prepareForDrawing()
		
		let width = frame.width / CGFloat(history.count)
		for (index, entry) in history.enumerated() {
			let x = CGFloat(index) * width
			guard x + width > dirtyRect.minX, x < dirtyRect.maxX else { continue }
			draw(entry, at: x, width: width)
		}
		
		finalizeDrawing()
	}
	
	func prepareForDrawing() {
		
	}
	
	func draw(_ entry: [Int: Double], at x: CGFloat, width: CGFloat) {
		fatalError("draw(_:x:width:) must be overridden!")
	}
	
	func finalizeDrawing() {
		
	}
	
	func color(forID id: Int) -> NSColor {
		let hueSteps = 16
		let brightnessSteps = 8
		let hue = CGFloat(id % hueSteps) / CGFloat(hueSteps)
		let brightness = 1 - CGFloat((id / hueSteps) % brightnessSteps) / CGFloat(brightnessSteps)
		return NSColor(hue: hue, saturation: 0.9, brightness: brightness, alpha: 1)
	}
	
	// for keyboard input (redirected to view controller)
	override var acceptsFirstResponder: Bool {
		return true
	}
}
