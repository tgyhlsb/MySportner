//
//  MSFourSquareParser.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSFourSquareParser : NSObject

+ (NSArray *)venuesFromJson:(NSDictionary *)json;

@end
