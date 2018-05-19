//
//  Standing.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug

struct Standing: Codable, Equatable, Comparable, CustomStringConvertible {
	enum CodingKeys: String, CodingKey { case team_name, games_played, wins, losses, ties, points }
	
	var team_name: String
	var games_played: Int
	var wins: Int
	var losses: Int
	var ties: Int
	var points: Int
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.team_name = try container.decode(String.self, forKey: .team_name)
		
		if let string = try? container.decode(String.self, forKey: .games_played) {
			self.games_played = Int(string) ?? 0
		} else {
			self.games_played = (try? container.decode(Int.self, forKey: .games_played)) ?? 0
		}
		
		if let string = try? container.decode(String.self, forKey: .wins) {
			self.wins = Int(string) ?? 0
		} else {
			self.wins = (try? container.decode(Int.self, forKey: .wins)) ?? 0
		}
		
		if let string = try? container.decode(String.self, forKey: .losses) {
			self.losses = Int(string) ?? 0
		} else {
			self.losses = (try? container.decode(Int.self, forKey: .losses)) ?? 0
		}
		
		if let string = try? container.decode(String.self, forKey: .ties) {
			self.ties = Int(string) ?? 0
		} else {
			self.ties = (try? container.decode(Int.self, forKey: .ties)) ?? 0
		}
		
		if let string = try? container.decode(String.self, forKey: .points) {
			self.points = Int(string) ?? 0
		} else {
			self.points = (try? container.decode(Int.self, forKey: .points)) ?? 0
		}
		
	}
	
	var description: String { return "\(self.team_name) (\(self.wins)-\(self.losses)-\(self.ties))" }
	
	static func ==(lhs: Standing, rhs: Standing) -> Bool {
		return lhs.team_name == rhs.team_name
	}
	
	static func <(lhs: Standing, rhs: Standing) -> Bool {
		return lhs.wins > rhs.wins
	}
	
	struct Payload: Codable {
		var standings: [Standing]
	}
}

extension Division {
	func fetchStandings(completion: @escaping ([Standing]) -> Void) {
		let url = Server.instance.buildURL(for: "standings", ["division_id": self.id])
		Connection(url: url)!.completion { conn, data in
			do {
				let payload = try JSONDecoder().decode(Standing.Payload.self, from: data.data)
				completion(payload.standings)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding standings")
			}
			}.error { conn, error in
				ErrorHandler.instance.handle(error, note: "downloading standings")
		}
	}
}
