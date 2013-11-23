//
//  MSFourSquareParser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFourSquareParser.h"
#import "MSVenue.h"

#define FOURSQUARE_KEY_CONTENT @"response"
#define FOURSQUARE_KEY_VENUES @"venues"

@implementation MSFourSquareParser

+ (NSArray *)venuesFromJson:(NSDictionary *)json
{
    NSDictionary *content = [json objectForKey:FOURSQUARE_KEY_CONTENT];
    
    NSArray *venuesInfo = [content objectForKey:FOURSQUARE_KEY_VENUES];
    
    NSMutableArray *tempVenues = [[NSMutableArray alloc] initWithCapacity:[venuesInfo count]];
    
    for (NSDictionary *venueInfo in venuesInfo)
    {
        [tempVenues addObject:[MSVenue venueWithInfo:venueInfo]];
    }
    
    return tempVenues;
}

@end
