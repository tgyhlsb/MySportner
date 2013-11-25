//
//  MSChooseSportsVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUser.h"

@interface MSChooseSportsVC : UIViewController

@property (strong, nonatomic) MSUser *user;

+ (MSChooseSportsVC *)newController;

@end
