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


#define FACEBOOK_VALUE_GENDER_MALE @"male"
#define FACEBOOK_KEY_GENDER @"gender"
#define FACEBOOK_KEY_EMAIL @"email"
#define FACEBOOK_KEY_BIRTHDAY @"birthday"
#define FACEBOOK_BIRTHDAY_FORMAT @"MM/dd/yyyy"

@interface MSSportner()

@property (weak, nonatomic) id tempActivityQueryTarget;
@property (nonatomic) SEL tempActivityQueryCallBack;

@property (weak, nonatomic) id tempSportnersQueryTarget;
@property (nonatomic) SEL tempSportnersQueryCallBack;

@end

@implementation MSSportner

@synthesize tempActivityQueryTarget = _tempActivityQueryTarget;
@synthesize tempActivityQueryCallBack = _tempActivityQueryCallBack;
@synthesize activities = _activities;

@synthesize tempSportnersQueryTarget = _tempSportnersQueryTarget;
@synthesize tempSportnersQueryCallBack = _tempSportnersQueryCallBack;
@synthesize sportners = _sportners;

@dynamic lastPlace;
@dynamic username;
@dynamic firstName;
@dynamic lastName;
@dynamic facebookID;
@dynamic birthday;
@dynamic gender;
@dynamic sports;
@dynamic sportLevels;
@dynamic imageFile;

+ (MSSportner *)currentSportner
{
    MSSportner *sportner = [MSUser currentUser].sportner;
    if (!sportner.sportners) {
        [sportner querySportnersWithTarget:nil callBack:nil];
    }
    return sportner;
}

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_SPORTNER;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[MSSportner class]]) {
        return [self isEqualToSportner:(MSSportner *)object];
    } else {
        return NO;
    }
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

- (NSArray *)getSports
{
    NSMutableArray *tempSports = [[NSMutableArray alloc] init];
    
    for (NSString *sportSlug in [self.sportLevels allKeys]) {
        MSSport *sport = [MSSport sportWithSlug:sportSlug];
        [tempSports addObject:sport];
    }
    
    return tempSports;
}

- (void)setLevel:(NSNumber *)level forSport:(MSSport *)sport
{
    if (level) {
        // set level
        NSMutableDictionary *tempSportLevels = [self.sportLevels mutableCopy];
        if (!tempSportLevels) {
            tempSportLevels = [[NSMutableDictionary alloc] init];
        }
        [tempSportLevels setObject:level forKey:sport.slug];
        self.sportLevels = tempSportLevels;
        [self addSport:sport];
    } else {
        // look for actual level
        NSNumber *oldLevel = [self levelForSport:sport];
        if (oldLevel) {
            // remove it
            NSMutableDictionary *tempSportLevels = [self.sportLevels mutableCopy];
            if (!tempSportLevels) {
                tempSportLevels = [[NSMutableDictionary alloc] init];
            }
            [tempSportLevels removeObjectForKey:sport.slug];
            self.sportLevels = tempSportLevels;
            [self removeSport:sport];
        }
    }
}

- (NSNumber *)levelForSport:(MSSport *)sport
{
    return [self.sportLevels objectForKey:sport.slug];
}

- (void)removeSport:(MSSport *)sport
{
    NSMutableArray *tempSports = [self.sports mutableCopy];
    if (!tempSports) {
        tempSports = [[NSMutableArray alloc] init];
    }
    [tempSports removeObject:sport.slug];
    self.sports = tempSports;
}

- (void)addSport:(MSSport *)sport
{
    NSMutableArray *tempSports = [self.sports mutableCopy];
    if (!tempSports) {
        tempSports = [[NSMutableArray alloc] init];
    }
    [tempSports addObject:sport.slug];
    self.sports = tempSports;
}

#pragma mark - ProfilePciture
@synthesize image = _image;

- (void)setImage:(UIImage *)image
{
    _image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
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
    
    PFQuery *activitiesQuery = [MSActivity query];
    [activitiesQuery whereKey:@"participant" equalTo:self];
    [activitiesQuery includeKey:@"owner"];
    [activitiesQuery includeKey:@"sport"];
    [activitiesQuery includeKey:@"comment"];
    [activitiesQuery findObjectsInBackgroundWithTarget:self selector:@selector(didFetchActivities:error:)];
}

- (void)didFetchActivities:(NSArray *)activities error:(NSError *)error
{
    if (!error) {
        self.activities = activities;
    } else {
        NSLog(@"%@",error);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tempActivityQueryTarget performSelector:self.tempActivityQueryCallBack withObject:activities withObject:error];
#pragma clang diagnostic pop
}

#pragma mark - Sportners

- (PFRelation *)sportnersRelation
{
    return [self relationforKey:@"sportner"];
}

- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack
{
    _tempSportnersQueryTarget = target;
    _tempSportnersQueryCallBack = callBack;
    
    PFQuery *sportnersQuery = [[self sportnersRelation] query];
    [sportnersQuery findObjectsInBackgroundWithTarget:self selector:@selector(didFetchSportners:error:)];
}

- (void)didFetchSportners:(NSArray *)sportners error:(NSError *)error
{
    if (!error) {
        self.sportners = sportners;
    } else {
        NSLog(@"%@",error);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:sportners withObject:error];
#pragma clang diagnostic pop
}

- (void)addSportner:(MSSportner *)sportner
{
    [[self sportnersRelation] addObject:sportner];
    [self saveInBackground];
    NSMutableArray *tempSportners = [self.sportners mutableCopy];
    [tempSportners addObject:sportner];
    self.sportners = tempSportners;
}

- (void)removeSportner:(MSSportner *)sportner
{
    [[self sportnersRelation] removeObject:sportner];
    [self saveInBackground];
    NSMutableArray *tempSportners = [self.sportners mutableCopy];
    [tempSportners removeObject:sportner];
    self.sportners = tempSportners;
}

@end
