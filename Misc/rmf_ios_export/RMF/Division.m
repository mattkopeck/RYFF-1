//
//  Division.m
//  AFFL
//
//  Created by Gjesdal on 13-01-30.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import "Division.h"

@implementation Division

@synthesize name;
@synthesize id;
@synthesize teams;


- (id)init { 
    if (self = [super init]) { // equivalent to "self does not equal nil"
        teams = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
