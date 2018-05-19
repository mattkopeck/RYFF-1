//
//  Division.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug

struct Division: Codable, Equatable, Comparable, CustomStringConvertible {
	static func fetch(completion: @escaping ([Division]) -> Void) {
		let url = Server.instance.buildURL(for: "division_teams")
		Connection(url: url)!.completion { conn, data in
			do {
				let payload = try JSONDecoder().decode(Payload.self, from: data.data)
				completion(payload.divisions)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding divisions")
			}
		}.error { conn, error in
			ErrorHandler.instance.handle(error, note: "downloading divisions")
		}
	}
	
	var id: String
	var name: String
	var teams: [Team]
	
	var description: String { return "\(self.name) (\(self.id)): \(self.teams.map({$0.description}).joined(separator: ","))" }
	
	static func ==(lhs: Division, rhs: Division) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func <(lhs: Division, rhs: Division) -> Bool {
		return lhs.name < rhs.name
	}
	
	struct Payload: Codable {
		var divisions: [Division]
	}
}
