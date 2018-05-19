//
//  VCAnnouncements.m
//  Saskatoon AFFL
//
//  Created by Scott Gjesdal on 12/19/2013.
//  Copyright (c) 2013 SportForm. All rights reserved.
//


#import "VCAnnouncements.h"
#import "Announcement.h"
#import "Reachability.h"
#import "urls.h"
#import "MBProgressHUD.h"
#import "AnnouncementTableViewCell.h"

@interface VCAnnouncements ()
    @property (nonatomic) Reachability *internetReachability;
@end

@implementation VCAnnouncements
@synthesize announcementTable;
NSMutableArray *announcements;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    announcements = [[NSMutableArray alloc] init];
    [self showHUD];
    NSLog(@"Getting Announcements from %@", url_announcements);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_announcements] ];
        [self performSelectorOnMainThread:@selector(fetchedAnnouncementData:) withObject:data waitUntilDone:YES];
    });
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
    
    //announcementTable.rowHeight = UITableViewAutomaticDimension;
    //announcementTable.estimatedRowHeight = 140;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [announcements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"AnnouncementTableViewCell";
    AnnouncementTableViewCell *cell = (AnnouncementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AnnouncementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Announcement *a = [announcements objectAtIndex:indexPath.row];
    //NSLog(@"Adding %@ - %@", a.dt, a.content);
    //cell.title.text = a.dt;
    //cell.content.text = a.content;
    //cell.backgroundColor = UIColor.greenColor;
    [cell updateWithTitle:a.dt content:a.content];
    
    return cell;
    
    /*
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    Announcement *a = [announcements objectAtIndex:indexPath.row];
    cell.textLabel.text = a.dt;
    cell.textLabel.font = [UIFont fontWithName:@"System" size:12.0f];
    cell.detailTextLabel.text = a.content;
    return cell;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Announcement *a = [announcements objectAtIndex:indexPath.row];
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{tableView.conte
    float additionalSpaceNeeded = 34+8;
    Announcement *a = [announcements objectAtIndex:indexPath.row];
    return additionalSpaceNeeded + [self heightForTextViewRectWithWidth:100 andText:a.content];
}
*/
-(CGFloat)heightForTextViewRectWithWidth:(CGFloat)width andText:(NSString *)text
{
    UIFont * font = [UIFont systemFontOfSize:12.0f];
    
    // this returns us the size of the text for a rect but assumes 0, 0 origin
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    // so we calculate the area
    CGFloat area = size.height * size.width;
    
    CGFloat buffer = 2.0f;
    
    // and then return the new height which is the area divided by the width
    // Basically area = h * w
    // area / width = h
    // for w we use the width of the actual text view
    return floor(area/width) + buffer;
}


- (void)showHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    //hud.dimBackground = YES;
    hud.label.text = @"Loading";
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[hud hideAnimated:YES];
}

- (void)fetchedAnnouncementData:(NSData *)responseData {
    [self hideHUD];
    
    NSLog(@"Fetched Announcements");
    
    if (responseData == nil) {
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
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    
    NSArray* jsonAnnouncements = [json objectForKey:@"announcements"]; //2
    
    [announcements removeAllObjects];
    
    for (int i = 0; i < [jsonAnnouncements count]; i++)
    {
        NSDictionary* jsonAnnouncement = [jsonAnnouncements objectAtIndex:i];
        
        NSString* dt = [jsonAnnouncement objectForKey:@"dt"];
        NSString* content = [jsonAnnouncement objectForKey:@"content"];
        NSString* title = [jsonAnnouncement objectForKey:@"title"];
        
        Announcement *a = [[Announcement alloc] init];
        a.dt = dt;
        a.title = title;
        a.content = content;
        //a.status = status;
        
        [announcements addObject:a];
    }
    
    if ([announcements count] == 0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Announcements"
                                     message:@"No announcements found."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:okButton];
    }
    
    [announcementTable reloadData];
}
@end
