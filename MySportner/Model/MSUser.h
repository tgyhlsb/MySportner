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

@protocol MSUserDelegate;


typedef NS_ENUM(int, MSUserGender) {
    MSUserGenderFemale,
    MSUserGenderMale,
};

@interface MSUser : PFUser <PFSubclassing>

@property (weak, nonatomic) id<MSUserDelegate> delegate;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic) MSUserGender gender;

- (void)tryLoginWithFacebook;
+ (void)tryLoginWithFacebook;

+ (MSUser *)currentUser;

@end

@protocol MSUserDelegate <NSObject>

- (void)userDidLogIn:(MSUser *)user;
- (void)userDidLogOut;

- (void)userDidSignUp:(MSUser *)user;
- (void)userSignUpDidFailWithError:(NSError *)error;

@end