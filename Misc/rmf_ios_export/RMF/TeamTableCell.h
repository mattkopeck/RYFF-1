//
//  ScheduleTableCell.h
//  AFFL
//
//  Created by Gjesdal on 13-01-29.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *team_image;
@property (nonatomic, weak) IBOutlet UILabel *team_name;
@property (nonatomic, weak) IBOutlet UILabel *coach_info;

@end
