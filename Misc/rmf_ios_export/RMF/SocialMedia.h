//
//  NSObject+SocialMedia.h
//  RMF
//
//  Created by Scott Gjesdal on 2018-04-12.
//  Copyright © 2018 Sportform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SocialMedia : NSObject
{
    NSString *link_url;
    NSString *title;
    UIImage *image;
}

@property (nonatomic, retain) NSString *link_url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *image;

@end


