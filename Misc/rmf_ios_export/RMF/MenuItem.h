//
//  Team.h
//  AFFL
//
//  Created by Gjesdal on 13-01-30.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
{
    NSString *label;
    NSString *imageName;
    NSString *segueName;
    NSString *code;
}

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *segueName;
@property (nonatomic, retain) NSString *code;
@end
