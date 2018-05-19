//
//  DataStore.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Gulliver

class DataStore {
	struct Notifications {
		static let divisionDataAvailable = Notifier("divisionDataAvailable")
		static let scheduleDataAvailable = Notifier("scheduleDataAvailable")
		static let standingDataAvailable = Notifier("standingDataAvailable")
	}
	static let instance = DataStore()
	
	let cacheURL = FileManager.libraryDirectoryURL.appendingPathComponent("cache.dat")
	var cache = Cache()
	
	init() {
		if let data = try? Data(contentsOf: self.cacheURL), let cache = try? JSONDecoder().decode(Cache.self, from: data) {
			self.cache = cache
		}
		
		self.fillCache()
	}
	
	func fillCache() {
		if !self.cache.hasDivisionData {
			Division.fetch { divisions in
				self.cache.divisions = divisions
				Notifications.divisionDataAvailable.notify()
				self.fillCache()
			}
			return
		}
		
		if !self.cache.hasFullScheduleData {
			for div in self.cache.divisions {
				for team in div.teams {
					if self.cache.teamSchedules[team.id] == nil {
						team.fetchSchedule { schedule in
							self.cache.teamSchedules[team.id] = schedule
							self.fillCache()
						}
						return
					}
				}
			}
		}
		Notifications.scheduleDataAvailable.notify()

		if !self.cache.hasFullStandingsData {
			for div in self.cache.divisions {
				if self.cache.divisionStandings[div.id] == nil {
					div.fetchStandings { standings in
						self.cache.divisionStandings[div.id] = standings
						self.fillCache()
					}
					return
				}
			}
		}
		Notifications.standingDataAvailable.notify()
		
		if let data = try? JSONEncoder().encode(self.cache) {
			try? data.write(to: self.cacheURL)
		}
	}
	
	struct Cache: Codable {
		var hasDivisionData: Bool { return self.divisions.count > 0 }
		var hasStandingsData: Bool { return self.divisionStandings.count > 0 }
		var hasScheduleData: Bool { return self.divisionStandings.count > 0 }

		var hasFullStandingsData: Bool { return self.hasDivisionData && self.divisionStandings.count == self.divisions.count }
		var hasFullScheduleData: Bool { return self.hasDivisionData && self.teamSchedules.count == self.numberOfTeams }
		
		var divisions: [Division] = []
		var divisionStandings: [String: [Standing]] = [:]
		var teamSchedules: [String: [ScheduledGame]] = [:]
		
		var numberOfTeams: Int { return self.divisions.reduce(0) { $0 + $1.teams.count }}
	}
}
