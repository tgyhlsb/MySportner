//
//  MSColorFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSColorFactory : NSObject

+ (UIColor *)mainColor;
+ (UIColor *)mainColorDark;
+ (UIColor *)mainColorShadow;

+ (UIColor *)facebookColorLight;
+ (UIColor *)facebookColorDark;

+ (UIColor *)whiteLight;
+ (UIColor *)whiteDark;

+ (UIColor *)redLight;
+ (UIColor *)redDark;
+ (UIColor *)redShadow;

+ (UIColor *)navigationColorLight;
+ (UIColor *)navigationColorDark;

+ (UIColor *)backgroundColorGrayLight;

+ (UIColor *)gray;
+ (UIColor *)grayLight;
+ (UIColor *)grayExtraLight;
+ (UIColor *)grayDark;


@end
