//
//  MSFontFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 01/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FONT_IDENTIFIER_TEXTFIELD @"textFieldFont"

@interface MSFontFactory : NSObject

+ (UIFont *)fontForFormTextField;
+ (UIFont *)fontForCommentLabel;
+ (UIFont *)fontForNavigationTitle;
+ (UIFont *)fontForButton;
+ (UIFont *)fontForButtonLight;
+ (UIFont *)fontForCellSportTitle;
+ (UIFont *)fontForTitle;
+ (UIFont *)fontForCellInfo;
+ (UIFont *)fontForCellAcivityTitle;
+ (UIFont *)fontForDrawerMenu;
+ (UIFont *)fontForGameProfileSportTitle;
+ (UIFont *)fontForGameProfileSportInfo;

+ (UIFont *)fontForGameProfileDay;
+ (UIFont *)fontForGameProfileTime;

+ (UIFont *)fontForActivityCellDay;
+ (UIFont *)fontForActivityCellTime;

@end
