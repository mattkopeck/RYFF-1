//
//  VCGameInfo.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCGameInfo.h"
#import "Reachability.h"
#import "Game.h"
#import "Team.h"
//#import <SDWebImage/UIImageView+WebCache.h>

@interface VCGameInfo ()
    @property (nonatomic) Reachability *internetReachability;
@end

@implementation VCGameInfo
@synthesize game;
@synthesize lblWhen;
@synthesize lblWhere;
@synthesize home_team_logo;
@synthesize home_team_name;
@synthesize away_team_logo;
@synthesize away_team_name;

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
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
    
    if (game != nil) {
        home_team_name.text = game.home_team;
        away_team_name.text = game.away_team;
        
//        [home_team_logo setImageWithURL:[NSURL URLWithString:game.home_team_logo] placeholderImage:[UIImage imageNamed:@"button_teams_blur.png"]];
        
//        [away_team_logo setImageWithURL:[NSURL URLWithString:game.away_team_logo] placeholderImage:[UIImage imageNamed:@"button_teams_blur.png"]];
        
        lblWhere.text = [NSString stringWithFormat:@"Field: %@", game.game_location];
        lblWhen.text = game.game_time;
    } else {       
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Game Info"
                                     message:@"No Game was Selected"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] == home_team_logo) {
        [self handleTapOnHomeImageView];
    }
    else if ([touch view] == away_team_logo) {
        [self handleTapOnAwayImageView];
    }
}


- (void) handleTapOnHomeImageView {
    [self performSegueWithIdentifier:@"ShowTeamInfoSegue2" sender:game.home_team_id];
}
- (void) handleTapOnAwayImageView {
    [self performSegueWithIdentifier:@"ShowTeamInfoSegue2" sender:game.away_team_id];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowTeamInfoSegue2"])
    {
        //VCTeamInfo *vc = [segue destinationViewController];
        //[vc setTeam_id: sender];
    }
}


- (IBAction)btnViewMap:(id)sender {
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@", game.latitude, game.longitude];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
@end
