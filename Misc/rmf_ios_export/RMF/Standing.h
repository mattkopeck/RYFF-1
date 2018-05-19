//
//  Standing.h
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#ifndef Standing_h
#define Standing_h

#import <Foundation/Foundation.h>

@interface Standing : NSObject
{
    NSString *team_name;
    NSString *games_played;
    NSString *wins;
    NSString *losses;
    NSString *ties;
    NSString *points;
}

@property (nonatomic, retain) NSString *team_name;
@property (nonatomic, retain) NSString *games_played;
@property (nonatomic, retain) NSString *wins;
@property (nonatomic, retain) NSString *losses;
@property (nonatomic, retain) NSString *ties;
@property (nonatomic, retain) NSString *points;

@end


#endif /* Standing_h */
