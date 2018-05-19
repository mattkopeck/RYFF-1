//
//  AppDelegate.h
//  RMF
//
//  Created by Scott Gjesdal on 2017-04-07.
//  Copyright © 2017 Sportform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

