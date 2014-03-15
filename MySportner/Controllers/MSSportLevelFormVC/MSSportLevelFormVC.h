//
//  MSSportLevelFormVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetController.h"
#import "MSSportLevel.h"

@interface MSSportLevelFormVC : MZFormSheetController

@property (nonatomic, strong) MSSportLevel *sportLevel;

@property (nonatomic) BOOL showUnSelectButton;

@property (nonatomic, strong) void (^doneBlock)(void);
@property (nonatomic, strong) void (^unSelectBlock)(void);

@end
