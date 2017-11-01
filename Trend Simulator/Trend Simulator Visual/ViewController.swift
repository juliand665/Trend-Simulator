// Copyright © 2017 Julian Dunskus. All rights reserved.

import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var popularityGraph: PopularityGraph!
	@IBOutlet weak var qualityGraph: QualityGraph!
	
	var simulation: Simulation!
	let simulationQueue = DispatchQueue(label: "simulation")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		simulation = Simulation(using: [popularityGraph, qualityGraph])
		simulationQueue.async(execute: simulation.run)
	}
}
