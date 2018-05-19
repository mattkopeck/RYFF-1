//
//  Team.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation

struct Team: Codable, Equatable, Comparable, CustomStringConvertible {
	var id: String
	var logo: String
	var division: String
	var name: String
	
	var description: String { return "\(self.name) (\(self.id))" }
	
	static func ==(lhs: Team, rhs: Team) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func <(lhs: Team, rhs: Team) -> Bool {
		return lhs.name < rhs.name
	}
	
}

