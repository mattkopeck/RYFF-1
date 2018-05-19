//
//  VCRules.m
//  RMF
//
//  Created by Scott Gjesdal on 2018-03-23.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import "VCRules.h"
#import "Reachability.h"
#import "urls.h"

@interface VCRules ()
@property (nonatomic) Reachability *internetReachability;
@end

@implementation VCRules
@synthesize wvSponsors;

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
    
    NSString *htmlString = @"Loading...";
    [wvSponsors loadHTMLString:htmlString baseURL: nil];
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    
    //2
    NSURL *url = [NSURL URLWithString:url_sponsors];
    
    //3
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (error == nil) {
                                                            if ([data length] > 0 && error == nil) [wvSponsors loadRequest:request];
                                                            else if (error != nil) NSLog(@"Error: %@", error);
                                                        }
                                                    });
                                                }];
    [dataTask resume];    // Executed First
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
                NSLog(@"Reachable on Announcements");
                
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

@end
