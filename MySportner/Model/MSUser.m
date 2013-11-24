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

#define DEFAULT_FIRSTNAME @""
#define DEFAULT_LASTNAME @""
#define DEFAULT_FACEBOOKID @""
#define DEFAULT_PASSWORD @""
#define DEFAULT_EMAIL @""
#define DEFAULT_BIRTHDAY [NSDate dateWithTimeIntervalSince1970:0]
#define DEFAULT_GENDER 0

@interface MSUser()

@property (nonatomic) BOOL isLoggingIn;

@end

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
    [fbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [fbDateFormatter dateFromString:stringDate];
}

#pragma mark Lazy instantiation

- (NSString *)firstName
{
    if (!_firstName) _firstName = DEFAULT_FIRSTNAME;
    return _firstName;
}

- (NSString *)lastName
{
    if (!_lastName) _lastName = DEFAULT_LASTNAME;
    return _lastName;
}

- (NSString *)facebookID
{
    if (!_facebookID) _facebookID = DEFAULT_FACEBOOKID;
    return _facebookID;
}

- (NSString *)password
{
    if (!_password) _password = DEFAULT_PASSWORD;
    return _password;
}

- (NSString *)email
{
    if (_email) _email = DEFAULT_EMAIL;
    return _email;
}

- (NSDate *)birthday
{
    if (!_birthday) _birthday = DEFAULT_BIRTHDAY;
    return _birthday;
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
    if (!self.isLoggingIn) {
        NSLog(@"Manages info");
        self.isLoggingIn = YES;
        [self setWithFacebookInfo:user];
        [self signUpToBackEnd];
    }
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
    if (self.facebookID && ![self.facebookID isEqualToString:DEFAULT_FACEBOOKID])
    {
        return self.facebookID;
    }
    else if (self.email && ![self.email isEqualToString:DEFAULT_EMAIL])
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
    
    [user signUpInBackgroundWithTarget:self
                              selector:@selector(handleSignUp:error:)];
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        [self signUpToBackEndDidSucceed];
    } else {
        [self signUpToBackEndDidFailWithError:error];
    }
}

- (void)signUpToBackEndDidSucceed
{
    if ([self.delegate respondsToSelector:@selector(userDidSignUp:)]) {
        [self.delegate userDidSignUp:self];
    }
    self.isLoggingIn = NO;
}

- (void)signUpToBackEndDidFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(userSignUpDidFailWithError:)]) {
        [self.delegate userSignUpDidFailWithError:error];
    }
    self.isLoggingIn = NO;
}

@end
