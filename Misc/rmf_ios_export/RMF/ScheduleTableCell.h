//
//  ScheduleTableCell.h
//  AFFL
//
//  Created by Gjesdal on 13-01-29.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScheduleTableCell : UITableViewCell {
    //Game *game;
}

@property (nonatomic, weak) IBOutlet UILabel *game_time;
@property (nonatomic, weak) IBOutlet UILabel *game_location;
@property (nonatomic, weak) IBOutlet UILabel *home_team;
@property (nonatomic, weak) IBOutlet UILabel *away_team;

@property (nonatomic, weak) IBOutlet Game *game;


@end
