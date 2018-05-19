//
//  VCTeams.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/1/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCTeams.h"
#import "Division.h"
#import "Team.h"
#import "VCSchedule.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "urls.h"
#import "TeamTableCell.h"

@interface VCTeams () {
    Team *team;
    NSMutableArray *divisions;
    NSInteger currDivisionPosition;
    NSInteger currTeamPosition;
}
@end

@implementation VCTeams

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    divisions = [[NSMutableArray alloc] init];
    
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url_divisions] ];
        [self performSelectorOnMainThread:@selector(fetchedTeamsListData:)
                               withObject:data waitUntilDone:YES];
    });
    
    // Connect data
    cmbTeamSelection.dataSource = self;
    cmbTeamSelection.delegate = self;

    currDivisionPosition = 0;
    currTeamPosition = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [divisions count];
    } else if (component == 1) {
        if ([divisions count] > 0) {
            return [[((Division *)[divisions objectAtIndex:currDivisionPosition]) teams] count];
        }
    }
    return 0;
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if ([divisions count] >= row + 1) {
            Division *d = (Division *)[divisions objectAtIndex:row];
            return d.name;
        }
    } else if (component == 1) {
        if ([divisions count] > 0) {
            Division *d = (Division *)[divisions objectAtIndex:currDivisionPosition];
            if ([d.teams count] >= row + 1) {
                Team *t = (Team *)[d.teams objectAtIndex:row];
                return t.name;
            }
        }
    }
    return @"Unknown";
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    if (component == 0) {
        currDivisionPosition = row;
        currTeamPosition = 0;
        [cmbTeamSelection reloadComponent:1];
        [cmbTeamSelection selectRow:currTeamPosition inComponent:1 animated:YES];
    } else if (component == 1) {
        currTeamPosition = row;
    }
    
    Division *d = (Division *)[divisions objectAtIndex:currDivisionPosition];
    Team *t = (Team *)[d.teams objectAtIndex:currTeamPosition];
    [self chooseTeam:t.id];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [divisions count];
}


- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (id)getTeamInfoURL:(NSString *)team_id  {
    return [NSURL URLWithString:[NSString stringWithFormat:url_teaminfo, team_id]];
}

- (void)chooseTeam:(NSString *)team_id {
    team = [[Team alloc] init];
    team.id = team_id;

    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [self getTeamInfoURL:team_id] ];
        [self performSelectorOnMainThread:@selector(fetchedTeamData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedTeamsListData:(NSData *)responseData {
    [self hideHUD];

    if (responseData == nil) {
        return;
    }
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* divisionsList = [json objectForKey:@"divisions"];
    
    [divisions removeAllObjects];
    
    for (int j = 0; j <= [divisionsList count] - 1; j++)
    {
        
        NSDictionary* jsonDivision = [divisionsList objectAtIndex:j];
        Division *d = [[Division alloc] init];
        NSString* div_id = [jsonDivision objectForKey:@"id"];
        NSString* div_name = [jsonDivision objectForKey:@"name"];
        NSArray* teamsList = [jsonDivision objectForKey:@"teams"];
        
        d.id = div_id;
        d.name = div_name;
        
        //NSLog(@"%ld teams found for %@", (long)[teamsList count], div_name);
        
        Team *t = [[Team alloc] init];
        t.id = @"-1";
        t.name = @"Choose";
        t.division = div_name;
        //t.logo = team_logo;
        [[d teams] addObject:t];

        for (int i = 0; i < [teamsList count]; i++)
        {
            NSDictionary* jsonTeam = [teamsList objectAtIndex:i];
            NSString* team_id = [jsonTeam objectForKey:@"id"];
            NSString* team_name = [jsonTeam objectForKey:@"name"];
            NSString* team_logo = [jsonTeam objectForKey:@"logo"];
            
            Team *t = [[Team alloc] init];
            t.id = team_id;
            t.name = team_name;
            t.division = div_name;
            t.logo = team_logo;
            [[d teams] addObject:t];
        }
        
        [divisions addObject:d];
    }
    
    [cmbTeamSelection reloadAllComponents];
}


- (void)fetchedTeamData:(NSData *)responseData {
    [self hideHUD];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    
    NSDictionary* jsonTeam = [json objectForKey:@"team_info"];
    
    for (int i = 0; i < [jsonTeam count]; i++)
    {
        
        //NSLog(@"%@", jsonTeam);
        
        if ([jsonTeam objectForKey:@"name"] != [NSNull null])
            team.name =  [(NSString *)[jsonTeam objectForKey:@"name"] stringByRemovingPercentEncoding];
        if ([jsonTeam objectForKey:@"logo_filename"] != [NSNull null])
            team.logo = [(NSString *)[jsonTeam objectForKey:@"logo_filename"] stringByRemovingPercentEncoding];
        if ([jsonTeam objectForKey:@"coach_name"] != [NSNull null])
            team.coach_name = [(NSString *)[jsonTeam objectForKey:@"coach_name"] stringByRemovingPercentEncoding];
        if ([jsonTeam objectForKey:@"coach_email"] != [NSNull null])
            team.coach_email = [(NSString *)[jsonTeam objectForKey:@"coach_email"] stringByRemovingPercentEncoding];
        if ([jsonTeam objectForKey:@"coach_phone"] != [NSNull null])
            team.coach_phone = [(NSString *)[jsonTeam objectForKey:@"coach_phone"] stringByRemovingPercentEncoding];
        if ([jsonTeam objectForKey:@"information"] != [NSNull null])
            team.information = [(NSString *)[jsonTeam objectForKey:@"information"] stringByRemovingPercentEncoding];
    }
    
    lblTeamName.text = team.name;
    //    [imgTeamLogo setImageWithURL:[NSURL URLWithString:team.logo] placeholderImage:[UIImage imageNamed:@"button_teams_blur.png"]];
    
    lblCoachName.text = team.coach_name;
    txtCoachEmail.text = team.coach_email;
    txtCoachPhone.text = team.coach_phone;
    txtTeamInfo.text = team.information;
}


- (IBAction)ViewTeamSchedule:(id)sender {
    [self performSegueWithIdentifier:@"segueTeamSchedule" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueTeamSchedule"])
    {
        VCSchedule *vc = [segue destinationViewController];
        //[vc setTeam:sender];
        [vc setDivision_id: ((Division *)divisions[currDivisionPosition]).id ];
        [vc setTeam_id: ((Team *)((Division *)divisions[currDivisionPosition]).teams[currTeamPosition]).id ];
    } else {
        NSLog(@"Using Unknown Segue");
    }
    
}

@end
