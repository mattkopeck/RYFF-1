//
//  Errors.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation

class ErrorHandler {
	static let instance = ErrorHandler()
	
	func handle(_ error: Error, note: String) {
		print("\(note): \(error)")
	}
}
