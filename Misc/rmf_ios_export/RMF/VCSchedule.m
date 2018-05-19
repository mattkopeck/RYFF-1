//
//  VCSchedule.m
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//

#import "VCSchedule.h"
#import "Reachability.h"
#import "Team.h"
#import "Division.h"
#import "Game.h"
#import "ScheduleTableCell.h"
#import "VCGameInfo.h"
#import "MBProgressHUD.h"
#import "urls.h"

@interface VCSchedule () {
    NSString *sDivisionId;
    NSMutableArray *games;
    NSMutableArray *divisions;
    NSMutableArray *teams;
    NSInteger currDivisionPosition;
    NSInteger currTeamPosition;
}
@property (nonatomic) Reachability *internetReachability;
@end

@implementation VCSchedule
    @synthesize tblTableView;
@synthesize team_id;
@synthesize division_id;

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
	// Do any additional setup after loading the view.
    
    divisions =[[NSMutableArray alloc] init];
    
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url_divisions] ];
        [self performSelectorOnMainThread:@selector(fetchedTeamsListData:)
                               withObject:data waitUntilDone:YES];
    });
    
    
    if (division_id != nil && team_id != nil) {
        [self chooseTeam:division_id :team_id];
    }
    
    
    // Connect data
    cmbTeamSelection.dataSource = self;
    cmbTeamSelection.delegate = self;
    
    currDivisionPosition = 0;
    currTeamPosition = 0;
    
    teams = [[NSMutableArray alloc] init];
    games = [[NSMutableArray alloc] init];
    
    tblTableView.dataSource = self;
    tblTableView.delegate = self;
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
	if (reachability == self.internetReachability)
	{
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable:        {
                NSLog(@"Not Reachable on Schedule");
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Network Unavailable"
                                             message:@"Please check your connection"
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                            }];
                [alert addAction:yesButton];
                break;
            }
            case ReachableViaWWAN:        {
                NSLog(@"Schedule Reachable on WWAN");
                break;
            }
            case ReachableViaWiFi:        {
                NSLog(@"Schedule Reachable on WiFi");
                break;
            }
        }
	}
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([games count] == 0) {
        [self EmptyMessage:@"No Games were found for this team." tableView:tableView];
    } else {
        [self EmptyMessage:@"" tableView:tableView];
    }
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > [games count]) {
        NSLog(@"Schedule Cell Out of Bounds");
        return nil;
    }
    
    static NSString *simpleTableIdentifier = @"ScheduleTableCell";
    
    ScheduleTableCell *cell = (ScheduleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[ScheduleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Game *g = [games objectAtIndex:indexPath.row];
    cell.game_time.text = g.game_time;
    cell.game_location.text = [NSString stringWithFormat:@"Field : %@", g.game_location];
    cell.home_team.text = g.home_team;
    cell.away_team.text = g.away_team;
    
    cell.game = g;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Game *g = [games objectAtIndex:indexPath.row];
    //[self performSegueWithIdentifier:@"ShowGameInfoSegue" sender:g];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowGameInfoSegue"]) {
        VCGameInfo *vc = [segue destinationViewController];
        [vc setGame:sender];
    }
}



// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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
    
    
    
    [self chooseTeam:d.id :t.id];
}

- (void)showHUD {
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    //hud.dimBackground = YES;
    //hud.label.text = @"Loading";
}

- (void)hideHUD {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (id)getTeamScheduleURL:(NSString *)_division_id :(NSString *)_team_id  {
    return [NSURL URLWithString:[NSString stringWithFormat:url_schedule, _division_id, _team_id]];
}

- (void)chooseTeam:(NSString *)_division_id :(NSString *)_team_id {
    if ([_team_id isEqualToString:@"-1"]) {
        [games removeAllObjects];
        [tblTableView reloadData];
        NSLog(@"Chose a -1 team");
        return;
    }
    NSLog(@"Team ID %@, Division ID %@", _team_id, _division_id);
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [self getTeamScheduleURL:_division_id :_team_id] ];
        [self performSelectorOnMainThread:@selector(fetchedScheduleData:)
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
        
        NSLog(@"%ld teams found for %@", (long)[teamsList count], div_name);
        
        
        Team *t = [[Team alloc] init];
        t.id = @"-1";
        t.name = @"Choose";
        t.division = div_name;
        //t.logo = team_logo;
        [[d teams] addObject:t];
        
        for (int i = 0; i < [teamsList count]; i++)
        {
            NSDictionary* jsonTeam = [teamsList objectAtIndex:i];
            NSString* _team_id = [jsonTeam objectForKey:@"id"];
            NSString* team_name = [jsonTeam objectForKey:@"name"];
            NSString* team_logo = [jsonTeam objectForKey:@"logo"];
            
            Team *t = [[Team alloc] init];
            t.id = _team_id;
            t.name = team_name;
            t.division = div_name;
            t.logo = team_logo;
            [[d teams] addObject:t];
        }
        
        [divisions addObject:d];
    }
    
    [cmbTeamSelection reloadAllComponents];
}


- (void)fetchedScheduleData:(NSData *)responseData {
    [self hideHUD];
    
    if (responseData == nil) {
        [games removeAllObjects];
        [tblTableView reloadData];
        return;
    }
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* jsonGames = [json objectForKey:@"games"];
    
    [games removeAllObjects];
    
    /*
    if ([jsonGames count] == 0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Schedule"
                                     message:@"No Games Found"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    */
    
    for (int i = 0; i < [jsonGames count]; i++)
    {
        // 1) Get the latest loan
        NSDictionary* jsonGame = [jsonGames objectAtIndex:i];
        
        Game *g = [[Game alloc] init];
        g.game_time = [jsonGame objectForKey:@"dt"];
        g.game_location = [jsonGame objectForKey:@"field_name"];
        
        g.home_team_id = [jsonGame objectForKey:@"home_team_id"];
        g.home_team_logo = [jsonGame objectForKey:@"home_team_logo"];
        g.home_team = [jsonGame objectForKey:@"home_team_name"];
        g.home_team_coach_name = [jsonGame objectForKey:@"home_team_coach_name"];
        g.home_team_coach_phone = [jsonGame objectForKey:@"home_team_coach_phone"];
        g.home_team_coach_email = [jsonGame objectForKey:@"home_team_coach_email"];
        
        g.away_team_id = [jsonGame objectForKey:@"away_team_id"];
        g.away_team_logo = [jsonGame objectForKey:@"away_team_logo"];
        g.away_team = [jsonGame objectForKey:@"away_team_name"];
        g.away_team_coach_name = [jsonGame objectForKey:@"away_team_coach_name"];
        g.away_team_coach_phone = [jsonGame objectForKey:@"away_team_coach_phone"];
        g.away_team_coach_email = [jsonGame objectForKey:@"away_team_coach_email"];
        
        g.latitude = [jsonGame objectForKey:@"field_lat"];
        g.longitude = [jsonGame objectForKey:@"field_long"];
        
        [games addObject:g];
    }
    
    NSLog(@"Found %ld Games", (long)[games count]);
    [tblTableView reloadData];
}


- (void)EmptyMessage:(NSString *)message tableView:(UITableView *)tableView {
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setFrame:CGRectMake(0,0,tableView.bounds.size.width,tableView.bounds.size.height)];
    [messageLabel setText:message];
    [messageLabel setTextColor:[UIColor blackColor]];
    [messageLabel setNumberOfLines:0];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setFont:[UIFont fontWithName:@"TrebuchetMS" size:15]];
    [messageLabel sizeToFit];
    [tableView setBackgroundView:messageLabel];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
@end
