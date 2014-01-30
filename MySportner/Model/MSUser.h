//
//  MSUser.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

#define FACEBOOK_READ_PERMISIONS @[@"email", @"user_birthday"]

#define FACEBOOK_DEFAULT_ID @[@"moufle.troufle", @"100007174114158"]

@protocol MSUserAuthentificationDelegate;


typedef NS_ENUM(int, MSUserGender) {
    MSUserGenderFemale,
    MSUserGenderMale,
};

@interface MSUser : PFUser <PFSubclassing>

@property (weak, nonatomic) id<MSUserAuthentificationDelegate> delegate;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic) MSUserGender gender;
@property (strong, nonatomic) NSDictionary *sportLevels;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) PFFile *imageFile;

@property (strong, nonatomic) NSArray *activities;

- (NSString *)fullName;

- (void)queryActivitiesWithTarget:(id)targer callBack:(SEL)callBack;
- (void)requestImageWithTarget:(id)target CallBack:(SEL)callback;
//- (void)joinActivity:(MSActivity *)activity withTarget:(id)target callBack:(SEL)callBack;
//- (void)leaveActivity:(MSActivity *)aci

+ (void)tryLoginWithFacebook:(id<MSUserAuthentificationDelegate>)sender;

+ (MSUser *)currentUser;

- (void)setSport:(NSInteger)sportKey withLevel:(NSInteger)level;
- (NSArray *)getSports;
- (NSInteger)sportLevelForSportIndex:(NSInteger)index defaultValue:(NSInteger)defaultValue;

- (PFRelation *)participantRelation;

@end

@protocol MSUserAuthentificationDelegate <NSObject>

@optional

- (void)userDidLogIn;
- (void)userDidLogOut;

- (void)userDidSignUp:(MSUser *)user;
- (void)userSignUpDidFailWithError:(NSError *)error;

@end