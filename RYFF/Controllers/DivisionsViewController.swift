//
//  DivisionsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class DivisionsViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Divisions"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DataStore.instance.cache.divisions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
		let div = DataStore.instance.cache.divisions[indexPath.row]
		
		cell.textLabel?.text = div.name

		
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let div = DataStore.instance.cache.divisions[indexPath.row]

		let controller = TeamsViewController(division: div)
		self.navigationController?.pushViewController(controller, animated: true)
	}

}
