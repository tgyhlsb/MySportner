//
//  MSUserMetaData.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MSSport.h"

#define PARSE_CLASSNAME_SPORTNER @"MSSportner"

typedef NS_ENUM(int, MSUserGender) {
    MSUserGenderFemale,
    MSUserGenderMale,
};

@interface MSSportner : PFObject <PFSubclassing>


@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic) MSUserGender gender;
@property (strong, nonatomic) NSArray *sports;
@property (strong, nonatomic) NSDictionary *sportLevels;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) PFFile *imageFile;

@property (strong, nonatomic) NSArray *activities;
@property (strong, nonatomic) NSArray *sportners;

+ (MSSportner *)currentSportner;

- (NSString *)fullName;
- (BOOL)isEqualToSportner:(MSSportner *)otherSportner;

- (PFRelation *)participantRelation;
- (void)queryActivitiesWithTarget:(id)targer callBack:(SEL)callBack;
- (void)requestImageWithTarget:(id)target CallBack:(SEL)callback;

- (PFRelation *)sportnersRelation;
- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack;

- (void)addSportner:(MSSportner *)sportner;
- (void)removeSportner:(MSSportner *)sportner;

- (NSArray *)getSports;
- (void)setLevel:(NSNumber *)level forSport:(MSSport *)sport;
- (NSNumber *)levelForSport:(MSSport *)sport;


- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo;


@end
