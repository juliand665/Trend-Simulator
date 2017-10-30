// Copyright © 2017 Julian Dunskus. All rights reserved.

import Foundation

extension Collection {
	func element(at index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
