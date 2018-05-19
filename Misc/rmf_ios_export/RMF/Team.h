//
//  Team.h
//  AFFL
//
//  Created by Gjesdal on 13-01-30.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject
{
    NSString *name;
    NSString *id;
    NSString *division;
    NSString *logo;
    NSString *information;
    
    NSString *coach_name;
    NSString *coach_phone;
    NSString *coach_email;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *division;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSString *information;


@property (nonatomic, retain) NSString *coach_name;
@property (nonatomic, retain) NSString *coach_phone;
@property (nonatomic, retain) NSString *coach_email;

@end