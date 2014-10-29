//
//  DTFacebookManager.h
//  Debty
//
//  Created by Tanguy Hélesbeux on 05/07/2014.
//  Copyright (c) 2014 Debty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define FACEBOOK_PERMISSIONS @[@"public_profile", @"email", @"user_friends"]

static NSString *DTNotificationFacebookUserLoggedIn = @"DTFacebookUserLoggedIn";
static NSString *DTNotificationFacebookUserLoggedOut = @"DTFacebookUserLoggetOut";

@interface MSFacebookManager : NSObject

+ (NSString *)facebookIDForUser:(id<FBGraphUser>)user;
+ (NSArray *)facebookIDForUserArray:(NSArray *)users;

+ (void)logOut;
+ (void)logInWithCompletionHandler:(FBRequestHandler)completionHandler;

+ (BOOL)isSessionAvailable;
+ (BOOL)isSessionOpen;

+ (void)fetchUserWithCompletionHandler:(FBRequestHandler)completionHandler;
+ (void)fetchFriendsWithCompletionHandler:(FBRequestHandler)completionHandler;

+ (void)handleAppColdStart;


+ (void)shareSignUp;

@end
