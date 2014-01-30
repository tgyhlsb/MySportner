//
//  MSSportnersVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MSSportnerCell.h"

@interface MSSportnersVC : MSCenterController <MSSportnerCellDelegate>


+ (MSSportnersVC *)newControler;


- (void)hideLoadingView;
- (void)showLoadingViewInView:(UIView*)v;

@end
