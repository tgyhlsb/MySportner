//
//  MSChooseSportsVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSportner.h"

@interface MSChooseSportsVC : UIViewController


@property (nonatomic, strong) void (^validateBlock)(void);
@property (strong, nonatomic) MSSportner *sportner;

+ (MSChooseSportsVC *)newController;

- (void)setValidateButtonTitle:(NSString *)title;

- (void)displayCongratulationPopUp;

@end
