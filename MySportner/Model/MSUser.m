//
//  MSUser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSUser.h"
#import <Parse/PFObject+Subclass.h>

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

@dynamic delegate;
@dynamic isLoggingIn;

- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    NSLog(@"%@", userInfo);
    self.facebookID = userInfo.id;
    self.firstName = userInfo.first_name;
    self.lastName = userInfo.last_name;
    if ([userInfo[FACEBOOK_KEY_GENDER] isEqualToString:FACEBOOK_VALUE_GENDER_MALE])
    {
        self.gender = MSUserGenderMale;
    }
    else{
        self.gender = MSUserGenderFemale;
    }
    self.email = [userInfo objectForKey:FACEBOOK_KEY_EMAIL];
    self.birthday = [self stringToDate:[userInfo objectForKey:FACEBOOK_KEY_BIRTHDAY]];
}

- (NSDate *)stringToDate:(NSString *)stringDate
{
    NSDateFormatter* fbDateFormatter = [[NSDateFormatter alloc] init];
    [fbDateFormatter setDateFormat:FACEBOOK_BIRTHDAY_FORMAT];
    [fbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [fbDateFormatter dateFromString:stringDate];
}

#pragma mark Lazy instantiation

@synthesize firstName = _firstName;

- (NSString *)firstName
{
    if (!_firstName) _firstName = DEFAULT_FIRSTNAME;
    return _firstName;
}

- (void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    self[@"firstname"] = firstName;
}

@synthesize lastName = _lastName;

- (NSString *)lastName
{
    if (!_lastName) _lastName = DEFAULT_LASTNAME;
    return _lastName;
}

- (void)setLastName:(NSString *)lastName
{
    _lastName = lastName;
    self[@"lastname"] = lastName;
}

@synthesize facebookID = _facebookID;

- (NSString *)facebookID
{
    if (!_facebookID) _facebookID = DEFAULT_FACEBOOKID;
    return _facebookID;
}

- (void)setFacebookID:(NSString *)facebookID
{
    _facebookID = facebookID;
    self[@"facebookID"] = facebookID;
}

@synthesize birthday = _birthday;

- (NSDate *)birthday
{
    if (!_birthday) _birthday = DEFAULT_BIRTHDAY;
    return _birthday;
}

- (void)setBirthday:(NSDate *)birthday
{
    _birthday = birthday;
    self[@"birthday"] = birthday;
}

@synthesize gender = _gender;

- (MSUserGender)gender
{
    return _gender;
}

- (void)setGender:(MSUserGender)gender
{
    _gender = gender;
    self[@"gender"] = @(gender);
}

#pragma mark Shared Instances

+ (MSUser *)currentUser
{
    return (MSUser *)[PFUser currentUser];
}

#pragma mark Parse mecanisms

- (void)requestFacebookInformations
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [[MSUser currentUser] setWithFacebookInfo:result];
            [[MSUser currentUser] saveInBackground];
        }
    }];
}

- (void)tryLoginWithFacebook
{
    [PFFacebookUtils logInWithPermissions:FACEBOOK_READ_PERMISIONS block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self requestFacebookInformations];
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

+ (void)tryLoginWithFacebook
{
    [[MSUser currentUser] tryLoginWithFacebook];
}

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
