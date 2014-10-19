//
//  MSSport.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>

#define PARSE_CLASSNAME_SPORT @"MSSport"

static NSString *MSSportWereFetch = @"MSSportWereFetch";

static NSString *MSNotificationSportsLoaded = @"MSNotificationSportsLoaded";

@interface MSSport : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;

//+ (NSInteger)keyForSportName:(NSString *)sportName;
//+ (NSString *)sportNameForKey:(NSInteger)sportKey;

+ (NSString *)parseClassName;
+ (NSArray *)allSports;
+ (BOOL)allSportsAreLoaded;


+ (MSSport *)sportWithSlug:(NSString *)slug;
+ (void)fetchAllSportsIfNeeded;
+ (void)fetchAllSports;

@end
