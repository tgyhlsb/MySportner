//
//  MSCreateAccountVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUser.h"


#define IMAGE_SIZE_FOR_UPLOAD 200

@interface MSVerifyAccountVC : UIViewController

@property (strong,nonatomic) MSUser *user;

+ (MSVerifyAccountVC *)newController;

@end
