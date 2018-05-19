//
//  Announcement.h
//  AFFL
//
//  Created by Gjesdal on 13-03-02.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject
{
    NSInteger id;
    NSString *dt;
    NSString *title;
    NSString *content;
    NSString *status;
}

@property (nonatomic, retain) NSString *dt;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *status;

- (NSString *)formattedOutput;

@end