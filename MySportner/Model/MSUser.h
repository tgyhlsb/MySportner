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
#import "MSSportner.h"

#define FACEBOOK_READ_PERMISIONS @[@"email", @"user_birthday"]

#define FACEBOOK_DEFAULT_ID @[@"moufle.troufle", @"100007174114158"]

@protocol MSUserAuthentificationDelegate;



@interface MSUser : PFUser <PFSubclassing>

@property (weak, nonatomic) id<MSUserAuthentificationDelegate> delegate;

@property (strong, nonatomic) MSSportner *sportner;



+ (void)tryLoginWithFacebook:(id<MSUserAuthentificationDelegate>)sender;

+ (MSUser *)currentUser;

@end

@protocol MSUserAuthentificationDelegate <NSObject>

@optional

- (void)userDidLogIn;
- (void)userDidLogOut;

- (void)userDidSignUp:(MSUser *)user;
- (void)userSignUpDidFailWithError:(NSError *)error;

@end