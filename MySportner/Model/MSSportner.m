//
//  MSUserMetaData.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportner.h"
#import "MSActivity.h"
#import "MSUser.h"
#import <Parse/PFObject+Subclass.h>
#import "MSSport.h"


#define FACEBOOK_VALUE_GENDER_MALE @"male"
#define FACEBOOK_KEY_GENDER @"gender"
#define FACEBOOK_KEY_EMAIL @"email"
#define FACEBOOK_KEY_BIRTHDAY @"birthday"
#define FACEBOOK_BIRTHDAY_FORMAT @"MM/dd/yyyy"

@interface MSSportner()

@property (weak, nonatomic) id tempActivityQueryTarget;
@property (nonatomic) SEL tempActivityQueryCallBack;

@end

@implementation MSSportner

@synthesize tempActivityQueryTarget = _tempActivityQueryTarget;
@synthesize tempActivityQueryCallBack = _tempActivityQueryCallBack;
@synthesize activities = _activities;

@dynamic username;
@dynamic firstName;
@dynamic lastName;
@dynamic facebookID;
@dynamic birthday;
@dynamic gender;
@dynamic sportLevels;
@dynamic imageFile;

+ (MSSportner *)currentSportner
{
    return [MSUser currentUser].sportner;
}

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_SPORTNER;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (BOOL)isEqualToSportner:(MSSportner *)otherSportner
{
    BOOL equal = YES;
    equal = equal && ([self.firstName isEqualToString:otherSportner.firstName]);
    equal = equal && ([self.lastName isEqualToString:otherSportner.lastName]);
    equal = equal && ([self.facebookID isEqualToString:otherSportner.facebookID]);
    equal = equal && ([self.birthday isEqualToDate:otherSportner.birthday]);
    equal = equal && (self.gender == otherSportner.gender);
    equal = equal && ([self.username isEqualToString:otherSportner.username]);
    
    return equal;
}

- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    self.facebookID = userInfo.id;
    self.firstName = userInfo.first_name;
    self.lastName = userInfo.last_name;
    if ([userInfo[FACEBOOK_KEY_GENDER] isEqualToString:FACEBOOK_VALUE_GENDER_MALE])
    {
        self.gender = MSUserGenderMale;
    }
    else{
        self.gender = MSUserGenderFemale;
    }
    self.birthday = [self stringToDate:[userInfo objectForKey:FACEBOOK_KEY_BIRTHDAY]];
}

- (NSDate *)stringToDate:(NSString *)stringDate
{
    NSDateFormatter* fbDateFormatter = [[NSDateFormatter alloc] init];
    [fbDateFormatter setDateFormat:FACEBOOK_BIRTHDAY_FORMAT];
    [fbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [fbDateFormatter dateFromString:stringDate];
}

#pragma mark - Sports
- (void)setSport:(NSInteger)sportKey withLevel:(NSInteger)level
{
    if (!self.sportLevels) {
        self.sportLevels = [[NSDictionary alloc] init];
    }
    NSMutableDictionary *tempSportLevels = [self.sportLevels mutableCopy];
    NSString *sportKeyString = [NSString stringWithFormat:@"%ld", (long)sportKey];
    [tempSportLevels setObject:@(level) forKey:sportKeyString];
    self.sportLevels = tempSportLevels;
}

- (NSArray *)getSports
{
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    for (NSString *sportKeyString in self.sportLevels) {
        NSInteger sportKey = [sportKeyString integerValue];

        NSInteger sportLevel = [self sportLevelForSportIndex:sportKey defaultValue:-1];
        if (sportLevel >= 0) {
            [sports addObject:[MSSport sportNameForKey:sportKey]];
        }
    }
    return sports;
}

- (NSInteger)sportLevelForSportIndex:(NSInteger)index defaultValue:(NSInteger)defaultValue
{
    NSDecimalNumber *sportLevel = [self.sportLevels valueForKey:[NSString stringWithFormat:@"%ld", (long)index]];
    return (sportLevel) ? [sportLevel integerValue] : defaultValue;
}

#pragma mark - ProfilePciture
@synthesize image = _image;

- (void)setImage:(UIImage *)image
{
    _image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    self.imageFile = [PFFile fileWithName:@"image.png" data:imageData];
}

- (UIImage *)image
{
    return _image;
}

- (void)requestImageWithTarget:(id)target CallBack:(SEL)callback
{
    if (self.imageFile) {
        [self.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.image = [UIImage imageWithData:data];
                if (callback) {
                    
                    // Same as : [target performSelector:@selector(callback)]
                    // Explanations : http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
                    // In order not to get warning
                    ((void (*)(id, SEL))[target methodForSelector:callback])(target, callback);
                }
            }
        }];
    }
}

#pragma mark - Activities & participation

- (PFRelation *)participantRelation
{
    return [self relationforKey:@"participant"];
}

- (void)queryActivitiesWithTarget:(id)target callBack:(SEL)callBack
{
    _tempActivityQueryTarget = target;
    _tempActivityQueryCallBack = callBack;
    
    NSLog(@"Change ativity to metadata");
    PFQuery *activitiesQuery = [MSActivity query];
    [activitiesQuery whereKey:@"participant" equalTo:self];
    [activitiesQuery includeKey:@"owner"];
    [activitiesQuery findObjectsInBackgroundWithTarget:self selector:@selector(didFetchActivities:error:)];
}

- (void)didFetchActivities:(NSArray *)activities error:(NSError *)error
{
    if (!error) {
        self.activities = activities;
    } else {
        NSLog(@"%@",error);
    }
    [self.tempActivityQueryTarget performSelector:self.tempActivityQueryCallBack withObject:activities withObject:error];
}

@end
