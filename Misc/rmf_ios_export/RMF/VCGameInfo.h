//
//  VCGameInfo.h
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface VCGameInfo : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *away_team_name;
@property (weak, nonatomic) IBOutlet UILabel *home_team_name;
@property (weak, nonatomic) IBOutlet UIImageView *home_team_logo;
@property (weak, nonatomic) IBOutlet UIImageView *away_team_logo;
@property (weak, nonatomic) IBOutlet UILabel *lblWhen;
@property (weak, nonatomic) IBOutlet UILabel *lblWhere;
//@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (nonatomic, strong) Game *game;
- (IBAction)btnViewMap:(id)sender;

@end
