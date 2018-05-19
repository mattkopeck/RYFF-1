//
//  StandingsTableViewCell.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
	@IBOutlet var teamNameLabel: UILabel!
	
	var standing: Standing? { didSet { self.updateUI() }}

	
	func updateUI() {
		guard let standing = self.standing else { return }
		
		self.teamNameLabel.text = standing.team_name
	}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
