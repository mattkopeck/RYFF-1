//
//  ScheduleTableCell.m
//  AFFL
//
//  Created by Gjesdal on 13-01-29.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import "TeamTableCell.h"

@implementation TeamTableCell

@synthesize team_name;
@synthesize team_image;
@synthesize coach_info;

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

@end
