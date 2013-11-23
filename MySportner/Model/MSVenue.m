//
//  MSVenue.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSVenue.h"

#define FOURSQUARE_KEY_IDENTIFIER @"id"
#define FOURSQUARE_KEY_NAME @"name"
#define FOURSQUARE_KEY_ADDRESS @"address"
#define FOURSQUARE_KEY_LATITUDE @"lat"
#define FOURSQUARE_KEY_LONGITUDE @"lng"
#define FOURSQUARE_KEY_DISTANCE @"distance"
#define FOURSQUARE_KEY_POSTALCODE @"postalCode"
#define FOURSQUARE_KEY_CITY @"city"
#define FOURSQUARE_KEY_STATE @"state"
#define FOURSQUARE_KEY_COUNTRY @"country"

#define FOURSQUARE_KEY_SUBKEY @"location"

@implementation MSVenue

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _identifier = [info objectForKey:FOURSQUARE_KEY_IDENTIFIER];
        _name = [info objectForKey:FOURSQUARE_KEY_NAME];
        
        info = [info objectForKey:FOURSQUARE_KEY_SUBKEY];
        
        _address = [info objectForKey:FOURSQUARE_KEY_ADDRESS];
//        CGFloat lat = [info valueForKey:FOURSQUARE_KEY_LATITUDE];
//        CGFloat lng = [info valueForKey:FOURSQUARE_KEY_LONGITUDE];
        _location = CGPointMake(0, 0);
        _distance = 0.0;
        _postalCode = 0;
        _city = [info objectForKey:FOURSQUARE_KEY_CITY];
        _state = [info objectForKey:FOURSQUARE_KEY_STATE];
        _country = [info objectForKey:FOURSQUARE_KEY_COUNTRY];
    }
    return self;
}

+ (MSVenue *)venueWithInfo:(NSDictionary *)info
{
    return [[MSVenue alloc] initWithInfo:info];
}

@end


//"id": "4cf62ada69aaa0909508822c",
//"name": "Stade de Gerland",
//"contact": {
//    "twitter": "ol"
//},
//"location": {
//    "address": "353 Avenue Jean Jaurès",
//    "lat": 45.72379852657417,
//    "lng": 4.83224630355835,
//    "distance": 4599,
//    "postalCode": "69007",
//    "cc": "FR",
//    "city": "Lyon",
//    "state": "Rhône-Alpes",
//    "country": "France"