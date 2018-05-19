//
//  ScheduleTableCell.m
//  AFFL
//
//  Created by Gjesdal on 13-01-29.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import "ScheduleTableCell.h"

@implementation ScheduleTableCell

@synthesize game_location;
@synthesize game_time;
@synthesize home_team;
@synthesize away_team;
@synthesize game;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ViewMap:(id)sender {
    NSLog(@"ViewMap");
    if (game != nil) {
        NSLog(@"Game is not nil");
        if (game.latitude != 0 && game.longitude != 0) {
            NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@", game.latitude, game.longitude];
            NSURL *url = [NSURL URLWithString:stringURL];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            NSLog(@"Invalid GPS for game");
        }
    } else {
        NSLog(@"Game is Nil");
    }
}

@end
