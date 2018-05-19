//
//  urls.m
//  RYFF
//
//  Created by Scott Gjesdal on 2015-05-01.
//  Copyright (c) 2015 SportForm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "urls.h"

#define APPVERSION @"2.0"

BOOL const show_announcements = YES;
BOOL const show_schedule = YES;
BOOL const show_teams = YES;
BOOL const show_photo_share = YES;
BOOL const show_playbook = NO;
BOOL const show_video_tutorials = YES;

#ifdef FLAVOUR
#if FLAVOUR==1
#define WEBSERVICEURL @"https://sportform.ca/c/ryff/webservice/"
NSString* const url_facebook =       @"https://www.facebook.com/ReginaNFLYouthFlagFootballLeague";
NSString* const url_facebook_id =    @"fb://profile/129107190629541";
NSString* const url_weather =        @"https://www.theweathernetwork.com/weather/canada/saskatchewan/regina";
NSString* const url_twitter =        @"twitter://user?screen_name=RYFFL";
NSString* const url_twitter_id =     @"546308260";
NSString* const url_email =          @"mailto:reginayouthflagfootball@gmail.com";
NSString* const url_instagram =     @"https://www.instagram.com/reginayouthflagfootball/";
NSString* const url_coach =      @"https://reginayouthflagfootball.com/spring/coaches";

BOOL const show_standings = YES;
BOOL const show_facebook = YES;
BOOL const show_twitter = YES;
BOOL const show_sponsors = YES;
BOOL const show_instagram = YES;
BOOL const show_weather = NO;
BOOL const show_email = YES;
BOOL const show_coach = YES;

BOOL const use_firebase = NO;

#elif FLAVOUR==4
#define WEBSERVICEURL @"https://sportform.ca/c/ryff_fall/webservice/"
NSString* const url_facebook =       @"https://www.facebook.com/RYCFL";
NSString* const url_facebook_id =    @"1386806234901337";
NSString* const url_weather =        @"https://www.theweathernetwork.com/weather/canada/saskatchewan/regina";
NSString* const url_twitter =        @"twitter://user?screen_name=RYCFL";
NSString* const url_twitter_id =     @"598089180";
NSString* const url_email =          @"mailto:reginacflyouthflagfootball@gmail.com";
NSString* const url_instagram =     @"https://www.instagram.com/reginayouthflagfootball/";
NSString* const url_coach =      @"https://reginayouthflagfootball.com/fall/coaches";

BOOL const show_standings = YES;
BOOL const show_facebook = YES;
BOOL const show_twitter = YES;
BOOL const show_sponsors = YES;
BOOL const show_instagram = YES;
BOOL const show_weather = NO;
BOOL const show_email = YES;
BOOL const show_coach = YES;

BOOL const use_firebase = NO;
#endif

NSString* const url_schedule =      WEBSERVICEURL@"games.json.php?ver="APPVERSION@"&division_id=%@&team_id=%@";
NSString* const url_standings =     WEBSERVICEURL@"standings.json.php?ver="APPVERSION@"&division_id=%@";
NSString* const url_stats =         WEBSERVICEURL@"stats.json.php?ver="APPVERSION@"&division_id=%@&team_id=%@";
NSString* const url_divisions =     WEBSERVICEURL@"division_teams.json.php?ver="APPVERSION;
NSString* const url_videos =        WEBSERVICEURL@"videos_ios.json.php?ver="APPVERSION;
NSString* const url_announcements = WEBSERVICEURL@"announcements.json.php?ver="APPVERSION;
NSString* const url_teaminfo = WEBSERVICEURL@"team_info.json.php?team_id=%@&ver="APPVERSION;
NSString* const url_sponsors =      WEBSERVICEURL@"sponsors.html.php?ver="APPVERSION;
NSString* const url_rules =      WEBSERVICEURL@"rules.html.php?ver="APPVERSION;

NSString* const url_photo_upload =      WEBSERVICEURL@"upload_photo.php?action=uploadPhoto&ver="APPVERSION;
#endif
