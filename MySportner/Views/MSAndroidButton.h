//
//  MSAndroidButton.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAndroidButton : UIButton

@property (strong, nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
