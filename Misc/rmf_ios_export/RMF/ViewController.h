//
//  ViewController.h
//  RYFF
//
//  Created by Scott Gjesdal on 1/1/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (strong, nonatomic) IBOutlet UITableView *tblMenuItems;
@property (strong, nonatomic) IBOutlet UIImageView *ivTitleBar;
@end
