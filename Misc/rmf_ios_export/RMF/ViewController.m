//
//  ViewController.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/1/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "ViewController.h"
#import "urls.h"
#import "MenuItem.h"
#import "HomeMenuItemTableViewCell.h"

@interface ViewController () {
    NSMutableArray *menuItems;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Show Flavour %d", FLAVOUR);
    
    menuItems =[[NSMutableArray alloc] init];
    
    MenuItem *item;
    
    if (show_announcements) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Announcements"];
        [item setImageName:@"megaphone.png"];
        [item setSegueName:@"segueAnnouncementsTable"];
        [menuItems addObject:item];
    }
    if (show_schedule) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Schedule"];
        [item setImageName:@"calendar.png"];
        [item setSegueName:@"segueSchedule"];
        [menuItems addObject:item];
    }
    if (show_standings) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Standings"];
        [item setImageName:@"numerical_sort.png"];
        [item setSegueName:@"segueStandings"];
        [menuItems addObject:item];
    }
    if (show_teams) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Teams"];
        [item setImageName:@"ic_group_black_48dp.png"];
        [item setSegueName:@"segueTeams"];
        [menuItems addObject:item];
    }
    /*
    if (show_photo_share) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Share photo"];
        [item setImageName:@"camera.png"];
        [item setSegueName:@"segueSharePhotos"];
        [menuItems addObject:item];
    }
    */
    if (show_weather) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Weather"];
        [item setImageName:@"ic_wb_sunny_black_48dp.png"];
        [item setSegueName:nil];
        [item setCode:@"weather"];
        [menuItems addObject:item];
    }
    
    if (show_playbook) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Playbook"];
        [item setImageName:@"stadium.png"];
        [item setSegueName:nil];
        [menuItems addObject:item];
    }
    
    if (show_coach) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Coach Info"];
        [item setImageName:@"coach.png"];
        [item setSegueName:nil];
        [item setCode:@"coach"];
        [menuItems addObject:item];
    }
    
    if (show_video_tutorials) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Video Tutorials"];
        [item setImageName:@"video.png"];
        [item setSegueName:@"segueVideoTutorials"];
        [menuItems addObject:item];
    }
    /*
    if (show_facebook) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Facebook"];
        [item setImageName:@"facebook.png"];
        [item setSegueName:nil];
        [item setCode:@"facebook"];
        [menuItems addObject:item];
    }
    
    if (show_twitter) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Twitter"];
        [item setImageName:@"twitter.png"];
        [item setSegueName:nil];
        [item setCode:@"twitter"];
        [menuItems addObject:item];
    }
    
    if (show_email) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Email Us"];
        [item setImageName:@"email.png"];
        [item setSegueName:nil];
        [item setCode:@"email"];
        [menuItems addObject:item];
    }
    
    if (show_instagram) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Instagram"];
        [item setImageName:@"instagram.png"];
        [item setSegueName:nil];
        [item setCode:@"instagram"];
        [menuItems addObject:item];
    }
    */
    if (show_facebook || show_twitter || show_email || show_instagram) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Social Media"];
        [item setImageName:@"instagram.png"];
        [item setSegueName:@"segueSocialMedia"];
        [menuItems addObject:item];
    }
    
    if (show_sponsors) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Sponsors"];
        [item setImageName:@"ic_sponsors.png"];
        [item setSegueName:@"segueSponsorsTable"];
        [menuItems addObject:item];
    }
    
    NSLog(@"Target name: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]);
    NSLog(@"Target Display name: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]);
    
    _ivTitleBar.image = [UIImage imageNamed:@"title_bar.png"];
    
    [self.navigationItem setTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [menuItems count]) {
        NSLog(@"Menu Items Cell Out of Bounds");
        return nil;
    }
    
    static NSString *simpleTableIdentifier = @"MenuItemCell";
    
    HomeMenuItemTableViewCell *cell = (HomeMenuItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[HomeMenuItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    cell.menuLabel.text = item.label;
    cell.menuImage.image = [UIImage imageNamed:item.imageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    
    if (item.segueName != nil) {
        [self performSegueWithIdentifier:item.segueName sender:item];
    } else if (item.code != nil && [UIApplication sharedApplication] != nil){
        
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *url = nil;
        
        if ([item.code isEqualToString:@"facebook"]) {
            url = [NSURL URLWithString:url_facebook];
            
            /*
             
            // check whether facebook is (likely to be) installed or not
            if ([app canOpenURL:[NSURL URLWithString:@"fb://"]]) {
                // Safe to launch the facebook app
                
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                [app openURL:[NSURL URLWithString:url_facebook_id] options:@{} completionHandler:nil];
#else
                [app openURL:[NSURL URLWithString:url_facebook_id]];
#endif
            } else {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                [app openURL:[NSURL URLWithString:url_facebook] options:@{} completionHandler:nil];
#else
                [app openURL:[NSURL URLWithString:url_facebook]];
#endif
            }
            */
            
        } else if ([item.code isEqualToString:@"twitter"]) { url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", url_twitter_id]];
            /*
            // check whether Twitter is (likely to be) installed or not
            if ([app canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", url_twitter_id]];
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                [app openURL:[NSURL URLWithString:url_twitter] options:@{} completionHandler:nil];
#else
                [app openURL:[NSURL URLWithString:url_twitter]];
#endif
            } else {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                [app openURL:[NSURL URLWithString:url_twitter] options:@{} completionHandler:nil];
#else
                [app openURL:[NSURL URLWithString:url_twitter]];
#endif
            }
            */
        
        } else if ([item.code isEqualToString:@"coach"]) {
            url = [NSURL URLWithString:url_coach];
        } else if ([item.code isEqualToString:@"email"]) {
            url = [NSURL URLWithString:url_email];
        } else if ([item.code isEqualToString:@"weather"]) {
            url = [NSURL URLWithString:url_weather];
        } else if ([item.code isEqualToString:@"instagram"]) {
            url = [NSURL URLWithString:url_instagram];
        }

        if (url != nil) {
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [app openURL:url options:@{} completionHandler:nil];
#else
        [app openURL:url];
#endif
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowGameInfoSegue"])
    {
    //    VCGameInfo *vc = [segue destinationViewController];
    //    [vc setGame:sender];
    }
}

@end
