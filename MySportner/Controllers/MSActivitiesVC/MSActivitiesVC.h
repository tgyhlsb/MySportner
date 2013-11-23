//
//  MSActivitiesVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCenterController.h"

@interface MSActivitiesVC : MSCenterController

@property (weak, nonatomic) IBOutlet UITableView *tableView;


+ (MSActivitiesVC *)newController;

@end
