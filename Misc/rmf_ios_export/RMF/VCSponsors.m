//
//  VCSponsors.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/1/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCSponsors.h"
#import "Reachability.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "urls.h"
#import "MBProgressHUD.h"
#import "Sponsor.h"

@interface VCSponsors ()
    @property (nonatomic) Reachability *internetReachability;
@end

@implementation VCSponsors
@synthesize sponsorTable;
NSMutableArray *sponsors;

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
    sponsors =[[NSMutableArray alloc] init];
    [self showHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"https://sportform.ca/c/ryff/webservice/sponsors.json.php"] ];
        [self performSelectorOnMainThread:@selector(fetchedVideoListData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sponsors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Sponsor *s = [sponsors objectAtIndex:indexPath.row];
    cell.textLabel.text = s.name;
    cell.textLabel.font = [UIFont fontWithName:@"System" size:12.0f];
    cell.detailTextLabel.text = s.details;
    //cell.imageView.image = [UIImage imageNamed:@"video_thumb_placeholder.png"];
    //cell.imageView.frame = CGRectMake(0,0,48,32);

    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Here we use the new provided setImageWithURL: method to load the web image
    //[cell.imageView.image setImageWithURL:[NSURL URLWithString:s.image_url]];
    if (s.image_url != nil && s.image_url.length > 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:s.image_url]
                 placeholderImage:[UIImage imageNamed:@"title_bar.png"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Sponsor *s = [sponsors objectAtIndex:indexPath.row];
    if (s.link_url != nil && s.link_url.length > 0) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:s.link_url];
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [app openURL:url options:@{} completionHandler:nil];
#else
        [app openURL:url];
#endif
    }
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

- (void)fetchedVideoListData:(NSData *)responseData {
    [self hideHUD];
    
    if (responseData == nil) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Sponsors"
                                     message:@"No sponsors were found"
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
    
    NSArray* videoList = [json objectForKey:@"sponsors"];
    
    [sponsors removeAllObjects];
    
    for (int i = 0; i <= [videoList count] - 1; i++)
    {
        NSDictionary* jsonAnnouncement = [videoList objectAtIndex:i];
        NSString* link_url = [jsonAnnouncement objectForKey:@"link_url"];
        NSString* image_url = [jsonAnnouncement objectForKey:@"image_url"];
        NSString* name = [jsonAnnouncement objectForKey:@"name"];
        NSString* details = [jsonAnnouncement objectForKey:@"details"];
        
        if (name == nil || name.length == 0) continue;
        
        Sponsor *s = [[Sponsor alloc] init];
        s.link_url = link_url;
        s.image_url = image_url;
        s.name = name;
        s.details = details;
        
        [sponsors addObject:s];
    }
    
    if ([videoList count] == 0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Sponsors"
                                     message:@"No sponsors are available"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:okButton];
    }
    
    [sponsorTable reloadData];
}


@end

