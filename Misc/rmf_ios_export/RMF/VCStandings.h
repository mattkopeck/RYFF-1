//
//  VCStandings.h
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCStandings : UIViewController
- (IBAction)btnShow:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pkDivision;
@property (weak, nonatomic) IBOutlet UITableView *tableStandings;
@end
