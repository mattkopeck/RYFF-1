//
//  VCTeamSchedule.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCTeamSchedule.h"
#import "Reachability.h"
#import "Team.h"
#import "Division.h"
#import "Game.h"
#import "ScheduleTableCell.h"
#import "VCGameInfo.h"
#import "MBProgressHUD.h"
#import "urls.h"

@interface VCTeamSchedule ()
    @property (nonatomic) Reachability *internetReachability;
@end

@implementation VCTeamSchedule
    @synthesize team;
    @synthesize tblTableView;

    NSMutableArray *games;
NSMutableArray *teams;
MBProgressHUD *hud;

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
    
    games = [[NSMutableArray alloc] init];
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];

    
    if (team != nil) {
        
        [self showHUD];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            [self getScheduleURL:team_id] ];
            [self performSelectorOnMainThread:@selector(fetchedStandingsData:)
                                   withObject:data waitUntilDone:YES];
        });
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Team Schedule"
                              message: @"No Team was Selected."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    

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
                NSLog(@"Not Reachable on Team Schedule");
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Network Unavailable"
                                             message:@"Please check your connection."
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
                NSLog(@"Team Schedule Reachable on WWAN");
                break;
            }
            case ReachableViaWiFi:        {
                NSLog(@"Team Schedule Reachable on WiFi");
                break;
            }
        }
	}
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Game *g = [games objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowGameInfoSegue2" sender:g];
}
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowGameInfoSegue2"])
    {
        VCGameInfo *vc = [segue destinationViewController];
        [vc setGame:sender];
    }
}

- (id)getScheduleURL:(NSString *)team_id  {
    return [NSURL URLWithString:[NSString stringWithFormat:url_teaminfo, team_id]];
}


- (void)showHUD {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    //hud.dimBackground = YES;
    hud.label.text = @"Loading";
}

- (void)hideHUD {
    [hud hide:YES];
}

- (void)fetchedStandingsData:(NSData *)responseData {
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
    
    
    if ([jsonGames count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Schedule"
                              message: @"No Games Found."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    
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
    
    [tblTableView reloadData];
}
@end
