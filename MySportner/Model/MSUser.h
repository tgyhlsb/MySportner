//
//  MSUser.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define FACEBOOK_READ_PERMISIONS @[@"email", @"user_birthday"]

@protocol MSUserDelegate;


typedef NS_ENUM(int, MSUserGender) {
    MSUserGenderFemale,
    MSUserGenderMale,
};

@interface MSUser : NSObject <FBLoginViewDelegate>

@property (weak, nonatomic) id<MSUserDelegate> delegate;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic) MSUserGender gender;

- (id)initWithFacebookInfo:(id<FBGraphUser>)userInfo;
+ (void)logInWithFacebookInfo:(id<FBGraphUser>)userInfo;
+ (void)logOut;

+ (MSUser *)sharedUser;

@end

@protocol MSUserDelegate <NSObject>

- (void)userDidLogIn:(MSUser *)user;
- (void)userDidLogOut;

- (void)userDidSignUp:(MSUser *)user;
- (void)userSignUpDidFailWithError:(NSError *)error;

@end