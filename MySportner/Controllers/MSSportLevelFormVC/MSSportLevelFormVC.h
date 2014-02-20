//
//  MSSportLevelFormVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetController.h"

@interface MSSportLevelFormVC : MZFormSheetController

@property (nonatomic) int level;

@property (nonatomic) BOOL showUnSelectButton;

@property (nonatomic, strong) void (^doneBlock)(void);
@property (nonatomic, strong) void (^unSelectBlock)(void);

@end
