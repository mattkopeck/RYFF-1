//
//  Division.h
//  AFFL
//
//  Created by Gjesdal on 13-01-30.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Division : NSObject
{
    NSString *name;
    NSString *id;
    NSMutableArray *teams;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSMutableArray *teams;

@end