//
//  MSSport.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define SAMPLE_SPORTS @[@"Tennis", @"Squash", @"Soccer", @"Football", @"Basketball", @"Volleyball", @"Running", @"Biking", @"Surf", @"Bodybuilding", @"Ping-Pong", @"Paddle-tennis", @"Gold", @"Ice-hockey", @"Curling", @"Trekking", @"Kite surfing", @"Wind surfing", @"Badminton", @"Swimming", @"Cross-fit", @"Judo", @"Horse-riding"]

#define PARSE_CLASSNAME_SPORT @"MSSport"

@interface MSSport : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *slug;

+ (void)fetchAllSportsIfNeeded;
+ (void)fetchAllSports;

+ (NSString *)parseClassName;

+ (NSInteger)keyForSportName:(NSString *)sportName;
+ (NSString *)sportNameForKey:(NSInteger)sportKey;


- (BOOL)isEqualToSport:(MSSport *)otherSport;

+ (NSArray *)allSports;

@end
