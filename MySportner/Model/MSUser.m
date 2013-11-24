//
//  MSUser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSUser.h"
#import <Parse/Parse.h>

#define FACEBOOK_VALUE_GENDER_MALE @"male"
#define FACEBOOK_KEY_GENDER @"gender"
#define FACEBOOK_KEY_EMAIL @"email"
#define FACEBOOK_KEY_BIRTHDAY @"birthday"
#define FACEBOOK_BIRTHDAY_FORMAT @"MM/dd/yyyy"

#define PARSE_KEY_FIRSTNAME @"firstname"
#define PARSE_KEY_LASTNAME @"lastname"
#define PARSE_KEY_FACEBOOKID @"facebookID"
#define PARSE_KEY_BIRTHDAY @"birthday"
#define PARSE_KEY_GENDER @"gender"

@implementation MSUser

- (id)initWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    self = [super init];
    if (self) {
        [self setWithFacebookInfo:userInfo];
    }
    return self;
}

- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    _facebookID = userInfo.id;
    _firstName = userInfo.first_name;
    _lastName = userInfo.last_name;
    if ([userInfo[FACEBOOK_KEY_GENDER] isEqualToString:FACEBOOK_VALUE_GENDER_MALE])
    {
        _gender = MSUserGenderMale;
    }
    else{
        _gender = MSUserGenderFemale;
    }
    _email = [userInfo objectForKey:FACEBOOK_KEY_EMAIL];
    _birthday = [self stringToDate:[userInfo objectForKey:FACEBOOK_KEY_BIRTHDAY]];
}

- (NSDate *)stringToDate:(NSString *)stringDate
{
    NSDateFormatter* fbDateFormatter = [[NSDateFormatter alloc] init];
    [fbDateFormatter setDateFormat:FACEBOOK_BIRTHDAY_FORMAT];
    return [fbDateFormatter dateFromString:stringDate];
}

#pragma mark Shared Instances

+ (MSUser *)sharedUser
{
    static MSUser *SharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!SharedUser) {
            SharedUser = [[MSUser alloc] init];
        } else {
            NSLog(@"/!\\ Did not unarchive user.");
        }
        
    });
    return SharedUser;
}

+ (void)logInWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    [[MSUser sharedUser] setWithFacebookInfo:userInfo];
}

+ (void)logOut
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"Log in");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"Log out");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"Fetched info");
    [MSUser logInWithFacebookInfo:user];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Facebook Error";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures since they can happen
        // outside of the app. You can inspect the error for more context
        // but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


#pragma mark Parse mecanisms

- (NSString *)username
{
    if (self.facebookID && ![self.facebookID isEqualToString:@""])
    {
        return self.facebookID;
    }
    else if (self.email && ![self.email isEqualToString:@""])
    {
        return self.email;
    }
    else
    {
        return nil;
    }
}

- (void)signUpToBackEnd
{
    PFUser *user = [PFUser user];
    user.username = [self username];
    user.password = self.password;
    user.email = self.email;
    
    // other fields can be set just like with PFObject
    user[PARSE_KEY_FIRSTNAME] = self.firstName;
    user[PARSE_KEY_LASTNAME] = self.lastName;
    user[PARSE_KEY_FACEBOOKID] = self.facebookID;
    user[PARSE_KEY_BIRTHDAY] = self.birthday;
    user[PARSE_KEY_GENDER] = @(self.gender);
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self signUpToBackEndDidSucceed];
        } else {
            [self signUpToBackEndDidFailWithError:error];
        }
    }];
}

- (void)signUpToBackEndDidSucceed
{
    if ([self.delegate respondsToSelector:@selector(userDidSignUp:)]) {
        [self.delegate userDidSignUp:self];
    }
}

- (void)signUpToBackEndDidFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(userSignUpDidFailWithError:)]) {
        [self.delegate userSignUpDidFailWithError:error];
    }
}

@end
