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

@property (strong, nonatomic) PFFile *imageFile;

@end

@implementation MSUser

@dynamic firstName;
@dynamic lastName;
@dynamic facebookID;
@dynamic birthday;
@dynamic gender;
@dynamic sportLevels;
@dynamic imageFile;

- (id)init
{
    self = [super init];
    if (self) {
        //        self.sportLevels = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)setSport:(NSInteger)sportKey withLevel:(NSInteger)level
{
    if (!self.sportLevels) {
        self.sportLevels = [[NSDictionary alloc] init];
    }
    NSMutableDictionary *tempSportLevels = [self.sportLevels mutableCopy];
    NSString *sportKeyString = [NSString stringWithFormat:@"%ld", (long)sportKey];
    [tempSportLevels setObject:@(level) forKey:sportKeyString];
    self.sportLevels = tempSportLevels;
}

- (NSArray *)getSports
{
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    for (NSString *sportKeyString in self.sportLevels) {
        NSInteger sportKey = [sportKeyString integerValue];
        
        NSInteger sportLevel = [self sportLevelForSportIndex:sportKey defaultValue:-1];
        if (sportLevel >= 0) {
            [sports addObject:[MSSport sportNameForKey:sportKey]];
        }
    }
    return sports;
}

- (NSInteger)sportLevelForSportIndex:(NSInteger)index defaultValue:(NSInteger)defaultValue
{
    NSDecimalNumber *sportLevel = [self.sportLevels valueForKey:[NSString stringWithFormat:@"%ld", (long)index]];
    return (sportLevel) ? [sportLevel integerValue] : defaultValue;
}

- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    //    NSLog(@"%@", userInfo);
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

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSDate *)stringToDate:(NSString *)stringDate
{
    NSDateFormatter* fbDateFormatter = [[NSDateFormatter alloc] init];
    [fbDateFormatter setDateFormat:FACEBOOK_BIRTHDAY_FORMAT];
    [fbDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [fbDateFormatter dateFromString:stringDate];
}

#pragma mark Image upload

@synthesize image = _image;

- (void)setImage:(UIImage *)image
{
    _image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);//UIImagePNGRepresentation(image);
    self.imageFile = [PFFile fileWithName:@"image.png" data:imageData];
}

- (UIImage *)image
{
    if (!_image) {
        [self requestImage];
    }
    return _image;
}

- (void)requestImage
{
    if (self.imageFile) {
        self.image = [[UIImage alloc] init];
//        PFFile *file = self.imageFile;
//        [self.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if (!error) {
//                self.image = [UIImage imageWithData:data];
//                // image can now be set on a UIImageView
//            }
//        }];
    }
}

#pragma mark Lazy instantiation
//
//@synthesize firstName = _firstName;
//
//- (NSString *)firstName
//{
//    if (!_firstName) _firstName = DEFAULT_FIRSTNAME;
//    return self[@"firstName"];
//}
//
//- (void)setFirstName:(NSString *)firstName
//{
//    _firstName = firstName;
//    self[@"firstName"] = firstName;
//}
//
//@synthesize lastName = _lastName;
//
//- (NSString *)lastName
//{
//    if (!_lastName) self.lastName = DEFAULT_LASTNAME;
//    return self[@"lastName"];
//}
//
//- (void)setLastName:(NSString *)lastName
//{
//    _lastName = lastName;
//    self[@"lastName"] = lastName;
//}
//
//@synthesize facebookID = _facebookID;
//
//- (NSString *)facebookID
//{
//    if (!_facebookID) self.facebookID = DEFAULT_FACEBOOKID;
//    return self[@"facebookID"];
//}
//
//- (void)setFacebookID:(NSString *)facebookID
//{
//    _facebookID = facebookID;
//    self[@"facebookID"] = facebookID;
//}
//
//@synthesize birthday = _birthday;
//
//- (NSDate *)birthday
//{
//    if (!_birthday) self.birthday = DEFAULT_BIRTHDAY;
//    return self[@"birthday"];
//}
//
//- (void)setBirthday:(NSDate *)birthday
//{
//    _birthday = birthday;
//    self[@"birthday"] = birthday;
//}
//
//@synthesize gender = _gender;
//
//- (MSUserGender)gender
//{
//    return [self[@"gender"] intValue];
//}
//
//- (void)setGender:(MSUserGender)gender
//{
//    _gender = gender;
//    self[@"gender"] = @(gender);
//}

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
            [self saveInBackground];
        }
    }];
}

+ (void)tryLoginWithFacebook:(id<MSUserAuthentificationDelegate>)sender
{
    [PFFacebookUtils logInWithPermissions:FACEBOOK_READ_PERMISIONS block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            MSUser *user = [MSUser currentUser];
            user.delegate = sender;
            
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                [user requestFacebookInformations];
                [user signUpToBackEndDidSucceed];
            } else {
                NSLog(@"User logged in through Facebook!");
                [user logInDidSucceed];
            }
        }
    }];
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
        [self requestImage];
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
