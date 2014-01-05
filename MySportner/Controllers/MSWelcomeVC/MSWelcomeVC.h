//
//  MSWelcomeVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSWelcomeVC : UIViewController

+ (MSWelcomeVC *)newController;

- (void)performLogin;

- (void)applicationIsBackFromBackground;

@end
