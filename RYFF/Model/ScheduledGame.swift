//
//  ScheduledGame.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug

struct ScheduledGame: Codable, Equatable, Comparable, CustomStringConvertible {
	var game_id: String
	var dt: Date
	var home_team_id: String
	var away_team_id: String
	var home_team_name: String
	var away_team_name: String
	var home_team_score: String
	var away_team_score: String
	var home_team_coach_name: String
	var away_team_coach_name: String
	var home_team_coach_phone: String
	var away_team_coach_phone: String
	var home_team_coach_email: String
	var away_team_coach_email: String
	var field_name: String
	var field_long: String
	var field_lat: String
	
	var description: String { return "\(self.away_team_name) vs. \(self.home_team_name): \(self.dt)" }
	
	static func ==(lhs: ScheduledGame, rhs: ScheduledGame) -> Bool {
		return lhs.game_id == rhs.game_id
	}
	
	static func <(lhs: ScheduledGame, rhs: ScheduledGame) -> Bool {
		return lhs.dt < rhs.dt
	}
	
	struct Payload: Codable {
		var games: [ScheduledGame]
	}
}

extension Team {
	func fetchSchedule(completion: @escaping ([ScheduledGame]) -> Void) {
		let url = Server.instance.buildURL(for: "games", ["team_id": self.id, "division_id": self.division])
		Connection(url: url)!.completion { conn, data in
			do {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(DateFormatter.scheduleFormatter)
				let payload = try decoder.decode(ScheduledGame.Payload.self, from: data.data)
				completion(payload.games)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding schedule")
			}
		}.error { conn, error in
			ErrorHandler.instance.handle(error, note: "downloading schedule")
		}
	}
	

}

extension DateFormatter {
	static let scheduleFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy, HH:mm a"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		return formatter
	}()

}
