// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var popularityGraph: PopularityGraph!
	@IBOutlet weak var qualityGraph: QualityGraph!
	
	var simulationThread: Thread?
	var simulation: Simulation!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		simulation = Simulation(using: [popularityGraph, qualityGraph])
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
	}
}
