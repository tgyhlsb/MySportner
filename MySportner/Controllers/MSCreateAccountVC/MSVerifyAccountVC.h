//
//  MSCreateAccountVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCenterController.h"
#import "MSUser.h"

typedef NS_ENUM(int, MSVerifyAccountUserState) {
    MSVerifyAccountUserStateNew,
    MSVerifyAccountUserStateAgreedConditions,
    MSVerifyAccountUserStateExisting,
};

#define IMAGE_SIZE_FOR_UPLOAD 200

@interface MSVerifyAccountVC : MSCenterController

@property (strong,nonatomic) MSUser *user;
@property (nonatomic) MSVerifyAccountUserState state;

+ (MSVerifyAccountVC *)newController;

@end
