# Trend Simulator

## How it works:

The simulation starts out with one person and one product (of quality 0), and simulates time in discrete intervals called “tick”s. Each tick, the following occurs:
1. Each person in the simulation ticks:
    1. The person’s marketing bonus for the currently selected product is decreased by 0.01, down to a minimum of 0.
    2. The person considers a random currently active product.
    3. If the product is better than the current product, the person switches to the product in consideration. Note that this comparison is between the respective biased qualities. This means that the current product’s quality is multiplied by (1 + loyalty), and that both qualities have the current marketing bonus added. This marketing bonus starts out at 10.
    4. If the considered product is not better, the person creates a new product with probability 0.01%, whose quality is that of the cur- rent product (which makes it better than the current product thanks to the marketing bonus).
2. Each product in the simulation has its quality increased by 0.01 times the fraction of people that use it.
3. With probability 1%, a new person is added. Any new person randomly gets assigned a loyalty property from 0 to the loyalty maximum.

## How to use it:

The best way to use this project is to download it and play around with it, mostly by modifying the parameters listed in [Simulation.swift](Trend%20Simulator/Trend%20Simulator/Simulation.swift)

### Visual

(can only be compiled in Xcode)

<img src="UI%20screenshot.png" alt="UI screenshot" />

* Press Space to pause and resume simulating.

* Press R to start a new simulation (this discards the current simulation).

* Press L to toggle live graph updating.

* Press S to save images and a text file for the current simulation state to disk. (Note that, while the live graphs are cut off after a certain number of values, file output is not.)

### Text-Based

(hopefully also compileable without Xcode/on other platforms)

To compile this, compile the sources from `Trend Simulator/Trend Simulator/` and `Trend Simulator/Trend Simulator Text/` together.
