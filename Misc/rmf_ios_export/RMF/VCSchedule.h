//
//  VCSchedule.h
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCSchedule : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tblTableView;
    IBOutlet UIPickerView *cmbTeamSelection;
}

@property (nonatomic, strong) NSString *team_id;
@property (nonatomic, strong) NSString *division_id;

@property (nonatomic, retain) UITableView *tblTableView;

@end
