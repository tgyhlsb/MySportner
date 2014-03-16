//
//  MSSport.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "MSSport.h"
#import "TKAlertCenter.h"

static NSArray *allSports;

@implementation MSSport

@dynamic name;
@dynamic slug;

+ (NSInteger)keyForSportName:(NSString *)sportName
{
    NSInteger key = [SAMPLE_SPORTS indexOfObject:sportName];
    return key;
}

+ (NSString *)sportNameForKey:(NSInteger)sportKey
{
    NSString *sportName = [SAMPLE_SPORTS objectAtIndex:sportKey];
    return sportName;
}

+ (MSSport *)sportWithSlug:(NSString *)slug
{
    for (MSSport *sport in allSports) {
        if ([sport.slug isEqualToString:slug]) {
            return sport;
        }
    }
    return nil;
}

+ (NSArray *)allSports
{
    return allSports;
}

- (BOOL)isEqualToSport:(MSSport *)otherSport
{
    return [self.slug isEqualToString:otherSport.slug];
}

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_SPORT;
}

+ (void)fetchAllSportsIfNeeded
{
    if (!allSports) {
        [MSSport fetchAllSports];
    }
}

+ (void)fetchAllSports
{
    PFQuery *query = [MSSport query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            allSports = objects;
            [[NSNotificationCenter defaultCenter] postNotificationName:MSSportWereFetch object:nil];
        } else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:[error localizedDescription]];
        }
    }];
}

@end
