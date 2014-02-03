//
//  MSUserMetaData.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

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
@property (strong, nonatomic) NSDictionary *sportLevels;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) PFFile *imageFile;

@property (strong, nonatomic) NSArray *activities;

+ (MSSportner *)currentSportner;

- (NSString *)fullName;
- (BOOL)isEqualToSportner:(MSSportner *)otherSportner;

- (PFRelation *)participantRelation;
- (void)queryActivitiesWithTarget:(id)targer callBack:(SEL)callBack;
- (void)requestImageWithTarget:(id)target CallBack:(SEL)callback;


- (void)setSport:(NSInteger)sportKey withLevel:(NSInteger)level;
- (NSArray *)getSports;
- (NSInteger)sportLevelForSportIndex:(NSInteger)index defaultValue:(NSInteger)defaultValue;


- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo;


@end
