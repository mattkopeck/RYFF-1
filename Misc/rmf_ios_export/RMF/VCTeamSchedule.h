//
//  VCTeamSchedule.h
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface VCTeamSchedule : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tblTableView;
}
@property (nonatomic, retain) UITableView *tblTableView;
@property (nonatomic, strong) Team *team;
@end