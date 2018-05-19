//
//  StandingsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Gulliver

class StandingsViewController: UITableViewController {
	var division: Division!
	var teams: [Standing] = []
	
	convenience init(division: Division) {
		self.init(style: .plain)
		self.division = division
		self.title = division.name
		self.teams = DataStore.instance.cache.divisionStandings[self.division.id] ?? []
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.register(cellClass: StandingsTableViewCell.self)
	}

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.teams.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier, for: indexPath) as! StandingsTableViewCell
		
		cell.standing = self.teams[indexPath.row]
		return cell
	}
}
