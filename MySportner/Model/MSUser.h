//
//  MSUser.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MSUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *facebookID;

- (id)initWithFacebookInfo:(id<FBGraphUser>)userInfo;
+ (void)logInWithFacebookInfo:(id<FBGraphUser>)userInfo;
+ (void)logOut;

+ (MSUser *)sharedUser;

@end
