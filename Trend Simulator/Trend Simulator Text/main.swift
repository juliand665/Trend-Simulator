//  Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

let simulation = Simulation(using: [Logger(), try! FileOutput()])
simulation.run()
