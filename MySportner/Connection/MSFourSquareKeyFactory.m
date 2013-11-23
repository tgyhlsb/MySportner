//
//  MSFourSqaureKeyFactory.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFourSquareKeyFactory.h"

@implementation MSFourSquareKeyFactory

+ (NSString *)keyForCategory:(MSFourSquareCategory)category
{
    switch (category) {
        case MSFourSquareCategoryBasketBall:
            return @"4bf58dd8d48988d1e1941735,4bf58dd8d48988d18b941735,4bf58dd8d48988d1ba941735";
            
        case MSFourSquareCategoryFootBall:
            return @"";
            
        default:
            return @"";
    }
}

@end
