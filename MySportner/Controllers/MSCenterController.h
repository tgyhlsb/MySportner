//
//  MSCenterController.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"

@interface MSCenterController : UIViewController

@property (nonatomic) BOOL hasDirectAccessToDrawer;

- (void)setTranslucentNavigationBar;

- (void)setNormalNavigationBar;

@end
