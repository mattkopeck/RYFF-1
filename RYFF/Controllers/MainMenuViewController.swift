//
//  MainMenuViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
	enum Option: String { case announcements, schedule, standings, teams
		var title: String { return self.rawValue.capitalized }
		var image: UIImage? {
			return UIImage(named: self.rawValue)
		}
		var isAvailable: Bool {
			switch self {
			case .announcements: return true
			case .schedule: return DataStore.instance.cache.hasFullScheduleData
			case .standings: return DataStore.instance.cache.hasFullStandingsData
			case .teams: return DataStore.instance.cache.hasDivisionData
			}
		}
	}
	
	var menuOptions: [Option] = [.announcements, .schedule, .standings, .teams]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataStore.Notifications.divisionDataAvailable.watch(self, message: #selector(divisionDataAvailable))
		DataStore.Notifications.scheduleDataAvailable.watch(self, message: #selector(scheduleDataAvailable))
		DataStore.Notifications.standingDataAvailable.watch(self, message: #selector(standingsDataAvailable))

		let imageView = UIImageView(image: UIImage(named: "nav_image"))
		imageView.contentMode = .scaleAspectFit
		self.navigationItem.titleView = imageView
	}
	
	@objc func divisionDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}
	
	@objc func scheduleDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}
	
	@objc func standingsDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch self.menuOptions[indexPath.row] {
		case .teams:
			self.navigationController?.pushViewController(DivisionsViewController(kind: .teams), animated: true)
			
		case .standings:
			self.navigationController?.pushViewController(DivisionsViewController(kind: .standings), animated: true)
			
		default: break
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.menuOptions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
		let option = self.menuOptions[indexPath.row]
		let enabled = option.isAvailable
		cell.textLabel?.text = option.title
		cell.imageView?.image = option.image
		cell.textLabel?.alpha = enabled ? 1.0 : 0.35
		cell.imageView?.alpha = enabled ? 1.0 : 0.35

		cell.accessoryType = .disclosureIndicator
		return cell
	}
}
