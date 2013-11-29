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

@property (nonatomic, strong) void (^closeBlock)(void);

@end
