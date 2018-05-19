//
//  VCSocialMedia.m
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import "VCSocialMedia.h"
#import "urls.h"
#import "MenuItem.h"
#import "HomeMenuItemTableViewCell.h"

@interface VCSocialMedia ()

@end

@implementation VCSocialMedia

@synthesize socialTable;
NSMutableArray *menuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Show Flavour %d", FLAVOUR);
    
    menuItems =[[NSMutableArray alloc] init];
    
    MenuItem *item;
    
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
    
    if (show_instagram) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Instagram"];
        [item setImageName:@"instagram.png"];
        [item setSegueName:nil];
        [item setCode:@"instagram"];
        [menuItems addObject:item];
    }
    
    if (show_photo_share) {
        item = [[MenuItem alloc] init];
        [item setLabel:@"Share photo"];
        [item setImageName:@"camera.png"];
        [item setSegueName:@"segueSharePhotos"];
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
    
    NSLog(@"Target name: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]);
    NSLog(@"Target Display name: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]);
    
    //[socialTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        } else if ([item.code isEqualToString:@"twitter"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", url_twitter_id]];
        } else if ([item.code isEqualToString:@"email"]) {
            url = [NSURL URLWithString:url_email];
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


@end
