//
//  NSObject+Sponsor.h
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sponsor : NSObject
{
    NSString *link_url;
    NSString *image_url;
    NSString *name;
    NSString *details;
}

@property (nonatomic, retain) NSString *link_url;
@property (nonatomic, retain) NSString *image_url;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *details;

@end

