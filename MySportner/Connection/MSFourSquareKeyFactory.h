//
//  MSFourSqaureKeyFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, MSFourSquareCategory) {
    MSFourSquareCategoryBasketBall,
    MSFourSquareCategoryFootBall
};

@interface MSFourSquareKeyFactory : NSObject

+ (NSString *)keyForCategory:(MSFourSquareCategory)category;

@end
