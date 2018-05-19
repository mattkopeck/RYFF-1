//
//  VCVideos.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCVideos.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Video.h"
#import "urls.h"
#import "MBProgressHUD.h"

@interface VCVideos ()

@end

@implementation VCVideos

@synthesize videosTable;

NSMutableArray *videos;


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
    videos =[[NSMutableArray alloc] init];
    
    [self showHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_videos] ];
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
    return [videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Video *v = [videos objectAtIndex:indexPath.row];
    cell.textLabel.text = v.title;
    cell.textLabel.font = [UIFont fontWithName:@"System" size:12.0f];
    cell.imageView.image = [UIImage imageNamed:@"video_thumb_placeholder.png"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Here we use the new provided setImageWithURL: method to load the web image
    if (v.thumbnail != nil && v.thumbnail.length > 0) {
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:v.thumbnail] placeholderImage:[UIImage imageNamed:@"video_thumb_placeholder.png"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Video *v = [videos objectAtIndex:indexPath.row];
    AVPlayer *player = [AVPlayer playerWithURL: [[NSURL alloc] initWithString:v.url] ];
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];
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
                                     alertControllerWithTitle:@"Videos"
                                     message:@"No videos were found"
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
    
    NSArray* videoList = [json objectForKey:@"videos"];
    
    [videos removeAllObjects];
    
    for (int i = 0; i <= [videoList count] - 1; i++)
    {
        NSDictionary* jsonAnnouncement = [videoList objectAtIndex:i];
        NSString* title = [jsonAnnouncement objectForKey:@"title"];
        NSString* thumbnail = [jsonAnnouncement objectForKey:@"thumbnail"];
        NSString* url = [jsonAnnouncement objectForKey:@"url"];
        
        Video *v = [[Video alloc] init];
        v.title = title;
        v.thumbnail = thumbnail;
        v.url = url;
        
        [videos addObject:v];
    }
    
    if ([videoList count] == 0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Videos"
                                     message:@"No videos are available"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:okButton];
    }
    
    [videosTable reloadData];
}


@end
