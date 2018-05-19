//
//  Video.h
//  SixaSide
//
//  Created by Gjesdal on 13-04-16.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject
{
    NSString *url;
    NSString *title;
    NSString *thumbnail;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumbnail;

@end