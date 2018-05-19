//
//  VCStandings.m
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//

#import "VCStandings.h"
#import "Division.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "urls.h"
#import "Standing.h"

@interface VCStandings ()
    @property (nonatomic) Reachability *internetReachability;
@end

@implementation VCStandings

@synthesize pkDivision;
@synthesize tableStandings;
NSMutableArray *divisions;
NSMutableArray *standings;
NSString *sDivisionId;

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
    standings =[[NSMutableArray alloc] init];
    
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url_divisions] ];
        [self performSelectorOnMainThread:@selector(fetchedTeamsListData:)
                               withObject:data waitUntilDone:YES];
    });
    
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
                NSLog(@"Reachable on Standings");
                
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
                break;
            }
            case ReachableViaWiFi:        {
                break;
            }
        }
	}
}


- (id)getStandingsURL {
    return [NSURL URLWithString:[NSString stringWithFormat:url_standings, sDivisionId]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == pkDivision) {
        return [divisions count];
    } else {
        NSLog(@"Standings: Unknown Count: 0");
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == pkDivision) {
        Division *d = [divisions objectAtIndex:row];
        return d.name;
    } else {
        return @"Standings: Blank";
    }
}

- (IBAction)btnShow:(id)sender {
    //NSLog(@"Standings: doneDivisionTapped");
    NSUInteger selectedRow = [pkDivision selectedRowInComponent:0];
    Division *d = [divisions objectAtIndex:selectedRow];
    sDivisionId = d.id;
    
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [self getStandingsURL] ];
        [self performSelectorOnMainThread:@selector(fetchedStandingsData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)fetchedTeamsListData:(NSData *)responseData {
    [self hideHUD];
    
    if (responseData == nil) {
        [divisions removeAllObjects];
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
        
        d.id = div_id;
        d.name = div_name;
        [divisions addObject:d];
    }
    
    [pkDivision reloadAllComponents];
}

- (void)fetchedStandingsData:(NSData *)responseData {
    [self hideHUD];
        
    if (responseData == nil) {
        [standings removeAllObjects];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Announcements"
                                     message:@"Failed to get announcements."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:okButton];
        return;
    }
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSString* status = [json objectForKey:@"status"];
    
    if (status != nil && [status isEqualToString:@"ERROR"]) {
        NSString* msg = [json objectForKey:@"msg"];
        if (msg != nil) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Standings"
                                         message:msg
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle your yes please button action here
                                       }];
            [alert addAction:okButton];
        }
    }
    
    NSArray* standingsList = [json objectForKey:@"standings"];
    
    [standings removeAllObjects];
    
    for (int j = 0; j <= [standingsList count] - 1; j++)
    {
        NSDictionary* jsonStanding = [standingsList objectAtIndex:j];
        Standing *s = [[Standing alloc] init];
        NSString* team_name = [jsonStanding objectForKey:@"team_name"];
        NSString* games_played = [jsonStanding objectForKey:@"games_played"];
        NSString* wins = [jsonStanding objectForKey:@"wins"];
        NSString* losses = [jsonStanding objectForKey:@"losses"];
        NSString* ties = [jsonStanding objectForKey:@"ties"];
        NSString* points = [jsonStanding objectForKey:@"points"];
        
        s.team_name = team_name;
        s.games_played = games_played;
        s.wins = wins;
        s.losses = losses;
        s.ties = ties;
        s.points = points;
        [standings addObject:s];
    }
    
    [tableStandings reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [standings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    Standing *s = [standings objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld) %@", (indexPath.row+1), s.team_name];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:12.0f];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"GP:%@, W:%@, L:%@, T:%@, P:%@", s.games_played, s.wins, s.losses, s.ties, s.points];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Standing *a = [standings objectAtIndex:indexPath.row];
}


@end
