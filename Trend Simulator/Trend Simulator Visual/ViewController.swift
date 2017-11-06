// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class ViewController: NSViewController, Outputter {
	@IBOutlet weak var popularityGraph: PopularityGraph!
	@IBOutlet weak var qualityGraph: QualityGraph!
	@IBOutlet weak var maxTickLabel: NSTextField!
	@IBOutlet weak var minQualityLabel: NSTextField!
	@IBOutlet weak var maxQualityLabel: NSTextField!
	
	var simulationThread: Thread?
	var simulation: Simulation!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		qualityGraph.maxQualityLabel = maxQualityLabel
		qualityGraph.minQualityLabel = minQualityLabel
		
		startSimulation()
	}
	
	func output(_ simulation: Simulation) {
		DispatchQueue.main.async {
			self.maxTickLabel.stringValue = "Tick \(simulation.currentTick)"
		}
	}
	
	func startSimulation() {
		simulation = Simulation(until: 10_000, using: [self, popularityGraph, qualityGraph])
		resumeSimulation()
	}
	
	func pauseSimulation() {
		simulationThread?.cancel()
		simulationThread = nil
	}
	
	func resumeSimulation() {
		simulationThread = Thread(block: simulation.run)
		simulationThread!.start()
	}
	
	override func keyDown(with event: NSEvent) {
		if event.characters == " " {
			if let _ = simulationThread {
				pauseSimulation()
			} else {
				resumeSimulation()
			}
		}
		if event.characters == "l" {
			popularityGraph.toggleLiveUpdate()
			qualityGraph.toggleLiveUpdate()
		}
		if event.characters == "r" {
			popularityGraph.reset()
			qualityGraph.reset()
			pauseSimulation()
			simulation.stop()
			startSimulation()
		}
		if event.characters == "s" {
			let panel = NSOpenPanel()
			panel.canChooseDirectories = true
			panel.canChooseFiles = false
			panel.prompt = "Save Here"
			panel.beginSheetModal(for: view.window!) { (response) in
				if response == .OK, let url = panel.url {
					self.saveImage(for: self.popularityGraph, to: url.appendingPathComponent("popularity.png"))
					self.saveImage(for: self.qualityGraph, to: url.appendingPathComponent("quality.png"))
				}
			}
		}
	}
	
	func saveImage(for graphView: GraphView, to url: URL) {
		let image = graphView.fullImage()
		let representation = NSBitmapImageRep(cgImage: image)
		let data = representation.representation(using: .png, properties: [:])!
		try! data.write(to: url)
	}
}
