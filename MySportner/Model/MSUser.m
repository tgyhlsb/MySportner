//
//  MSUser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSUser.h"
#import "MSSport.h"
#import <Parse/PFObject+Subclass.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MSActivity.h"
#import "MSSportner.h"

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

#define DEFAULT_FIRSTNAME @""
#define DEFAULT_LASTNAME @""
#define DEFAULT_FACEBOOKID @""
#define DEFAULT_PASSWORD @""
#define DEFAULT_EMAIL @""
#define DEFAULT_BIRTHDAY [NSDate dateWithTimeIntervalSince1970:0]
#define DEFAULT_GENDER 0

@interface MSUser()


@property (weak, nonatomic) id tempActivityQueryTarget;
@property (nonatomic) SEL tempActivityQueryCallBack;

@end

@implementation MSUser

//@synthesize firstName = _firstName;
//@synthesize lastName = _lastName;
//@synthesize facebookID = _facebookID;
//@synthesize birthday = _birthday;
//@synthesize gender = _gender;
//@synthesize sportLevels = _sportLevels;
//@synthesize imageFile = _imageFile;
//
//@synthesize activities = _activities;

@dynamic sportner;


@synthesize tempActivityQueryTarget = _tempActivityQueryTarget;
@synthesize tempActivityQueryCallBack = _tempActivityQueryCallBack;


- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    self.sportner = [[MSSportner alloc] init];
    self.sportner.username = self.username;
    self.email = [userInfo objectForKey:FACEBOOK_KEY_EMAIL];
    [self.sportner setWithFacebookInfo:userInfo];
}

- (NSDate *)stringToDate:(NSString *)stringDate
{
    NSDateFormatter* fbDateFormatter = [[NSDateFormatter alloc] init];
    [fbDateFormatter setDateFormat:FACEBOOK_BIRTHDAY_FORMAT];
    [fbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [fbDateFormatter dateFromString:stringDate];
}

@synthesize delegate = _delegate;

- (id<MSUserAuthentificationDelegate>)delegate
{
    return _delegate;
}

- (void)setDelegate:(id<MSUserAuthentificationDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark Shared Instances

+ (MSUser *)currentUser
{
    if ([PFUser currentUser])
    {
        return (MSUser *)[PFUser currentUser];
    }
    else
    {
        return nil;
    }
}

#pragma mark Parse mecanisms

- (void)requestFacebookInformations
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self setWithFacebookInfo:result];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self signUpToBackEndDidSucceed];
            }];
        }
    }];
}

+ (void)tryLoginWithFacebook:(id<MSUserAuthentificationDelegate>)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PFFacebookUtils logInWithPermissions:FACEBOOK_READ_PERMISIONS block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                MSUser *user = [MSUser currentUser];
                user.delegate = sender;
                
                if (user.isNew) {
                    NSLog(@"User signed up and logged in through Facebook!");
                    [user requestFacebookInformations];
                } else {
                    NSLog(@"User logged in through Facebook!");
                    [user logInDidSucceed];
                }
            }
        }];
    });

}

- (void)signUpToBackEnd
{
    //    PFUser *user = [PFUser user];
    //    user.username = self.email;
    //    user.password = self.password;
    //    user.email = self.email;
    //
    //    // other fields can be set just like with PFObject
    //    user[PARSE_KEY_FIRSTNAME] = self.firstName;
    //    user[PARSE_KEY_LASTNAME] = self.lastName;
    //    user[PARSE_KEY_FACEBOOKID] = self.facebookID;
    //    user[PARSE_KEY_BIRTHDAY] = self.birthday;
    //    user[PARSE_KEY_GENDER] = @(self.gender);
    
    self.sportner.username = self.username;
    [self signUpInBackgroundWithTarget:self
                              selector:@selector(handleSignUp:error:)];
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
    if (!error) {
        [self signUpToBackEndDidSucceed];
    } else {
        [self signUpToBackEndDidFailWithError:error];
    }
}

#pragma mark Delegate notifications

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

- (void)logInDidSucceed
{
    if ([self.delegate respondsToSelector:@selector(userDidLogIn)])
    {
        [self.delegate userDidLogIn];
    }
}

- (void)logOutDidSucceed
{
    if ([self.delegate respondsToSelector:@selector(userDidLogOut)])
    {
        [self.delegate userDidLogOut];
    }
}

@end
