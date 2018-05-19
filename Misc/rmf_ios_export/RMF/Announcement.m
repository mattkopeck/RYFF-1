//
//  Announcement.m
//  AFFL
//
//  Created by Gjesdal on 13-03-02.
//  Copyright (c) 2013 Scott Gjesdal. All rights reserved.
//

#import "Announcement.h"

@implementation Announcement

@synthesize dt;
@synthesize title;
@synthesize content;
@synthesize status;

- (NSString *)formattedOutput
{
    return [NSString stringWithFormat:@"<div style='border-bottom: thin solid #DDD; margin-bottom: 10px; padding-bottom: 5px;'><strong>%@</strong><br /><p style='margin: 10px''>%@</p></div>", dt, content];
}

@end
