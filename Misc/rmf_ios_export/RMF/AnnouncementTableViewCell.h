//
//  AnnouncementTableViewCell.h
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell
@property (strong, nonnull) IBOutlet UILabel *title;
@property (strong, nonnull) IBOutlet UILabel *content;

- (void)updateWithTitle:(NSString *)strTitle content:(NSString *)strContent;
@end
