//
//  game.h
//  AFFL
//
//  Created by Gjesdal on 13-01-29.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
{
    NSString *game_time;
    NSString *game_location;
    NSString *game_status;
    NSString *home_team;
    NSString *home_team_id;
    NSString *home_team_logo;
    NSString *home_team_coach_name;
    NSString *home_team_coach_phone;
    NSString *home_team_coach_email;
    NSString *away_team;
    NSString *away_team_id;
    NSString *away_team_logo;
    NSString *away_team_coach_name;
    NSString *away_team_coach_phone;
    NSString *away_team_coach_email;
    
    NSString *latitude;
    NSString *longitude;
}

@property (nonatomic, retain) NSString *game_time;
@property (nonatomic, retain) NSString *game_location;
@property (nonatomic, retain) NSString *game_status;
@property (nonatomic, retain) NSString *home_team;
@property (nonatomic, retain) NSString *home_team_id;
@property (nonatomic, retain) NSString *home_team_logo;
@property (nonatomic, retain) NSString *home_team_coach_name;
@property (nonatomic, retain) NSString *home_team_coach_phone;
@property (nonatomic, retain) NSString *home_team_coach_email;
@property (nonatomic, retain) NSString *away_team;
@property (nonatomic, retain) NSString *away_team_id;
@property (nonatomic, retain) NSString *away_team_logo;
@property (nonatomic, retain) NSString *away_team_coach_name;
@property (nonatomic, retain) NSString *away_team_coach_phone;
@property (nonatomic, retain) NSString *away_team_coach_email;

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

@end
