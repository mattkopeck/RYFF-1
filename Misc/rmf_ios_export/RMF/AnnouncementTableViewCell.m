//
//  AnnouncementTableViewCell.m
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

@implementation AnnouncementTableViewCell
@synthesize title;
@synthesize content;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateWithTitle:(NSString *)strTitle content:(NSString *)strContent {

    title.text = strTitle;
    content.text = strContent;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
