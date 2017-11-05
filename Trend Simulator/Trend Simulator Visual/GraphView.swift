// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class GraphView: NSView, Outputter {
	typealias Entry = [Int: Double]
	
	let historyMax = 128
	private(set) var fullHistory: [Entry] = []
	var history: ArraySlice<Entry> {
		return fullHistory.suffix(historyMax)
	}
	
	func output(_ simulation: Simulation) {
		fullHistory.append(historyEntry(from: simulation))
		
		DispatchQueue.main.async { 
			self.needsDisplay = true
		}
	}
	
	func historyEntry(from simulation: Simulation) -> Entry {
		fatalError("historyEntry(from:) must be overridden!")
	}
	
	func draw<History>(_ history: History, in context: CGContext, height: CGFloat) where History: Collection, History.Element == GraphView.Entry, History.IndexDistance == Int {
		prepareForDrawing(in: context)
		
		let width: CGFloat = 1
		var x: CGFloat = 0
		for entry in history {
			draw(entry, at: x, width: width, height: height, in: context)
			x += width
		}
		
		finalizeDrawing(in: context)
	}
	
	override func draw(_ dirtyRect: NSRect) {
		let context = NSGraphicsContext.current!.cgContext
		context.saveGState()
		let scale = frame.width / CGFloat(historyMax)
		context.scaleBy(x: scale, y: scale)
		
		draw(history, in: context, height: frame.height / scale)
		
		context.restoreGState()
	}
	
	func prepareForDrawing(in context: CGContext) {
		
	}
	
	func draw(_ entry: Entry, at x: CGFloat, width: CGFloat, height: CGFloat, in context: CGContext) {
		fatalError("draw(_:x:width:in:) must be overridden!")
	}
	
	func finalizeDrawing(in context: CGContext) {
		
	}
	
	func fullImage() -> CGImage {
		let width = fullHistory.count
		let height = 512
		let context = CGContext(data: nil,
								width: width,
								height: height,
								bitsPerComponent: 8,
								bytesPerRow: 4 * width,
								space: CGColorSpaceCreateDeviceRGB(),
								bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
		
		draw(fullHistory, in: context, height: CGFloat(height))
		
		return context.makeImage()!
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
