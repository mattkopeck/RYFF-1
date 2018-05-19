//
//  VCTeams.h
//  RYFF
//
//  Created by Scott Gjesdal on 1/1/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCTeams : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UILabel *lblTeamName;
    IBOutlet UIImageView *imgTeamLogo;
    IBOutlet UIButton *btnTeamSchedule;
    IBOutlet UILabel *lblCoachName;
    
    IBOutlet UIPickerView *cmbTeamSelection;
    
    IBOutlet UITextView *txtCoachPhone;
    IBOutlet UITextView *txtCoachEmail;
    IBOutlet UITextView *txtTeamInfo;
}

@end
